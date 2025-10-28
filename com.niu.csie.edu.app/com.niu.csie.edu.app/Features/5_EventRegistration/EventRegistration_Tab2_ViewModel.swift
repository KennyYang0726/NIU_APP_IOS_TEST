import SwiftUI
import Combine



@MainActor
final class EventRegistration_Tab2_ViewModel: ObservableObject {
    
    // --- 狀態 ---
    @Published var isListVisible: Bool = false
    @Published var isOverlayVisible = true
    @Published var overlayText: LocalizedStringKey = "loading"
    
    // --- WebView 相關 ---
    let webProvider: WebView_Provider
    // --- 全域注射 ---
    private let sso = SSOIDSettings.shared
    // --- JS ---
    let jsGetData: String = """
        (function() { 
            var data = []; 
            var count = document.querySelector('.col-md-11.col-md-offset-1.col-sm-10.col-xs-12.col-xs-offset-0').querySelectorAll('.row.enr-list-sec').length;
            for(let i=0; i<count; i++) {
                let row = document.querySelectorAll('.row.enr-list-sec')[i]; // 報名項目 父容器
                let row_state = document.querySelectorAll('.row.bg-warning')[i]; // 報名狀態 父容器
                let dialog = row.querySelector('.table'); // 活動詳情 Dialog 父容器
                let name = row.querySelector('h3').innerText.trim(); // 名稱
                let department = row.querySelector('.col-sm-3.text-center.enr-list-dep-nam.hidden-xs').title.split('：')[1].trim(); // 主辦單位
                let state = row_state.querySelector('.text-danger.text-shadow').innerText.split('：')[1].trim(); // 報名狀態 (正取/候補/現場)
                let event_state = row.querySelector('.btn.btn-danger').innerText.trim(); // 活動狀態
                let eventSerialID = row.querySelector('p').innerText.split('：')[1].split(' ')[0].trim(); // 活動編號
                let eventTime = row.querySelector('.fa-calendar').parentElement.innerText.replace(/\\s+/g,'').replace('~','~\\n').trim(); // 活動時間
                let eventTime_formatted = eventTime.replace('~','起')+'止'.trim(); // 活動時間 格式化版
                let eventLocation = row.querySelector('.fa-map-marker').parentElement.innerText.trim(); // 活動地點
                let eventDetail = dialog.querySelectorAll('tr')[3].querySelectorAll('td')[1].textContent.replace(/\\s+/g,'').replace('<br>','\\n').replace('\"','').trim(); // 活動說明
                let contactInfoText = dialog.querySelectorAll('tr')[5].querySelectorAll('td')[1].innerHTML; // 聯絡資訊(3項)
                let contactInfos = contactInfoText.split('<br>').map(function(info) {
                    return info.replace(/<[^>]*>/g,'').trim();
                }); // 以 [index] 抓取3項資訊
                let Related_links = dialog.querySelectorAll('tr')[6].querySelectorAll('td')[1].textContent.replace(/\\s+/g,'').trim(); // 相關連結
                let Remark = dialog.querySelectorAll('tr')[7].querySelectorAll('td')[1].textContent.replace(/\\s+/g,'').replace('<br>','\\n').replace('\"','').trim(); // 備註
                let Multi_factor_authentication = dialog.querySelectorAll('tr')[8].querySelectorAll('td')[1].textContent.replace(/\\s+/g,'').replace('<br>','\\n').replace('\"','').trim(); // 多元認證
                let eventRegisterTime = dialog.querySelectorAll('tr')[9].querySelectorAll('td')[1].textContent.replace(/\\s+/g,'').replace('~','~\\n').trim(); // 報名時間
                // let eventPeople = row.querySelector('.fa-user-plus').parentElement.innerText.replace(/\\s+/g,'').replace('，','人\\n')+'人'.trim(); // 報名人數
                data[i] = {name, department, state, event_state, eventSerialID, eventTime, eventTime_formatted, eventLocation, eventDetail, contactInfoName: contactInfos[0], contactInfoTel: contactInfos[1], contactInfoMail: contactInfos[2], Related_links, Remark, Multi_factor_authentication, eventRegisterTime};
            }
            return JSON.stringify(data);
        })();
        """
    
    
    init() {
        let ccsysURL = sso.ccsys
        // 初始化 WebView
        self.webProvider = WebView_Provider(
            initialURL: "https://ccsys.niu.edu.tw/SSO/" + ccsysURL,
            userAgent: .desktop
        )
        setupCallbacks()
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
                if progress < 1.0 {
                    self.isOverlayVisible = true
                }
            }
        }
    }
    
    private func handlePageFinished(url: String?) {
        switch url {
        case "https://ccsys.niu.edu.tw/MvcTeam/Act":
            webProvider.load(url: "https://ccsys.niu.edu.tw/MvcTeam/Act/ApplyMe")
        case "https://ccsys.niu.edu.tw/MvcTeam/Act/ApplyMe":
            isOverlayVisible = false
            /*
            webProvider.evaluateJS(jsHideElements) { [weak self] _ in
                self?.showPage()
            }*/
        default:
            break
        }
    }
    
    // --- 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility） ---
    private func showPage() {
        isListVisible = true
        isOverlayVisible = false
        // print("顯示頁面完成")
    }
}
