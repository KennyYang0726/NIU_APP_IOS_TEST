import SwiftUI
import Combine



@MainActor
final class EUNI1ViewModel: ObservableObject {
    // --- 狀態 ---
    @Published var isOverlayVisible = true
    @Published var overlayText: LocalizedStringKey = "loading"
    @Published var isRefreshing = false
    
    @Published var showToast = false
    
    @Published var courseList: [EUNI1_ListViewModel] = []
    
    // --- 控制旗標 ---
    private var shouldSkipOverlay = false     // 控制是否顯示 overlay
    private var isManualReload = false        // 用於 refresh 按鈕
    
    // --- WebView 管理 ---
    let webProvider: WebView_Provider
    
    // --- SSO 設定 ---
    private let sso = SSOIDSettings.shared
    // --- 取 semester ---
    private let appSettings: AppSettings
    // --- 儲存 EUNI Course Data ---
    private let EUNIcourseData = UserDefaults(suiteName: "EUNIcourseData")!
    
    // --- JS (這裡先用 __SEMESTER__ 佔位，後續由真實學年度取代) ---
    private let jsGetCourse: String = """
        (function() {
            var elements = document.querySelectorAll('i.fa.fa-graduation-cap');
            var result = [];
            elements.forEach(function(element) {
                var parent = element.closest('a');
                const Semester = '__SEMESTER__';
                if (parent) {
                    var title = parent.textContent.trim();
                    if (title.includes(Semester)) {
                        result.push({
                            title: title,
                            href: parent.href
                        });
                    }
                }
            });
            return JSON.stringify(result);
        })();
        """
    
    init() {
        // 初始化 AppSettings
        self.appSettings = AppSettings()
        let euniURL = sso.EUNI
        // 初始化 WebView
        self.webProvider = WebView_Provider(
            initialURL: "https://ccsys.niu.edu.tw/SSO/" + euniURL,
            userAgent: .desktop
        )
        setupCallbacks()
        // 自動載入資料判斷，不顯示 overlay
        if EUNIcourseData.object(forKey: "課程_0_名稱") != nil {
            shouldSkipOverlay = true
            loadCoursesFromUserDefaults()
        }
    }
    
    // --- 綁定 WebView 回呼事件 ---
    private func setupCallbacks() {
        webProvider.onPageFinished = { [weak self] url in
            guard let self = self else { return }
            Task { @MainActor in
                self.handlePageFinished(url: url)
            }
        }
        
        webProvider.onProgressChanged = { [weak self] progress in
            guard let self = self else { return }
            Task { @MainActor in
                // self.overlayText = LocalizedStringKey("loading")
                // 僅在非快取載入時顯示 overlay
                if !self.shouldSkipOverlay {
                    if progress < 1.0 {
                        self.isOverlayVisible = true
                    }
                }
            }
        }
    }
    
    // --- 頁面載入完成時的處理邏輯 ---
    private func handlePageFinished(url: String?) {
        // print("頁面載入完成: \(url ?? "未知網址")")
        let dontHasCourseData = EUNIcourseData.object(forKey: "課程_0_名稱") == nil
        // 若手動 reload，強制重新抓資料
        if isManualReload {
            isManualReload = false
            fetchCourseData()
            return
        }
        // 若無資料，進行第一次抓取
        if dontHasCourseData {
            fetchCourseData()
        }
    }
    
    // --- 從外部觸發的手動重新載入 ---
    func reloadWebAndFetch() {
        isManualReload = true
        shouldSkipOverlay = false
        isOverlayVisible = true
        webProvider.reload()  // 重新載入 WebView 頁面
    }
    
    private func fetchCourseData() {
        let jsGetCourse_fix = jsGetCourse.replacingOccurrences(of: "__SEMESTER__", with: String(appSettings.semester))
        webProvider.evaluateJS(jsGetCourse_fix) { [weak self] courses in
            guard let self = self else { return }
            saveCourseData(fromJSON: courses)
        }
    }
    
    private func saveCourseData(fromJSON raw: String?) {
        // 1) 防守：確保有內容
        guard let json = raw, !json.isEmpty else { return }
        // 2) 解析成陣列：元素含 title / href
        guard let data = json.data(using: .utf8) else { return }
        guard let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }

        // 3) 清空舊資料（等價於 SharedPreferences.edit().clear()）
        //    這裡是清空該 suiteName 的所有 key
        EUNIcourseData.removePersistentDomain(forName: "EUNIcourseData")
        EUNIcourseData.synchronize()

        // 4) 寫入資料，並在遇到與第一筆同名或同 ID 時結束
        var firstTitle: String?
        var firstId: String?

        var index = 0
        for item in array {
            guard let title = item["title"] as? String,
                  let href  = item["href"] as? String else { continue }

            // 取出 id= 後面的值
            let idPart: String = {
                if let range = href.range(of: "id=") {
                    return String(href[range.upperBound...])
                } else {
                    return href // 若沒有 id=，就保留原字串，避免資料遺失
                }
            }()

            if index == 0 {
                firstTitle = title
                firstId = idPart
            } else if title == firstTitle || idPart == firstId {
                // 與第一筆重複，停止（對應 Android 的 break）
                break
            }

            // 依照 Android 的 key 命名規則寫入
            EUNIcourseData.set(title, forKey: "課程_\(index)_名稱")
            EUNIcourseData.set(idPart, forKey: "課程_\(index)_ID")

            index += 1
        }

        // 5) 同步
        EUNIcourseData.synchronize()

        // 6) 完成後觸發 loadCoursesFromUserDefaults 通知 EUNI1_ListViewModel
        loadCoursesFromUserDefaults()
    }
    
    
    private func loadCoursesFromUserDefaults() {
        guard let defaults = UserDefaults(suiteName: "EUNIcourseData") else { return }
        
        // 取得所有 key
        let allKeys = defaults.dictionaryRepresentation().keys
        
        // 過濾出所有「課程_index_名稱」的 key，並依序取出 index
        let courseIndexes: [Int] = allKeys.compactMap { key in
            if key.hasPrefix("課程_"), key.hasSuffix("_名稱") {
                let middle = key.replacingOccurrences(of: "課程_", with: "")
                    .replacingOccurrences(of: "_名稱", with: "")
                return Int(middle)
            }
            return nil
        }
        .sorted() // 確保順序正確

        var tempList: [EUNI1_ListViewModel] = []
        
        for index in courseIndexes {
            let nameKey = "課程_\(index)_名稱"
            let idKey   = "課程_\(index)_ID"
            
            if let name = defaults.string(forKey: nameKey),
               let id = defaults.string(forKey: idKey) {
                tempList.append(EUNI1_ListViewModel(name: name, id: id))
            }
        }
        courseList = tempList
        // 完成後顯示畫面
        showPage()
    }

    
    // --- 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility） ---
    private func showPage() {
        isOverlayVisible = false
        // 顯示 toast 控制
        if self.shouldSkipOverlay == false {
            showToast = true
        }
        // print("顯示頁面完成")
    }
}
