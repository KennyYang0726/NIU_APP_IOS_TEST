import SwiftUI



struct ZuvioView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    @StateObject private var WebZuvio = WebView_Provider(
        initialURL: "https://irs.zuvio.com.tw/student5/irs/index",
        userAgent: .mobile
    )
    
    @State private var showOverlay = true
    @State private var overlayText: LocalizedStringKey = "loading"
    // @State private var overlayText = "載入中..."
    
    let jsHideElements = """
    ['forum', 'zook', 'direno', 'match', 'setting'].forEach(function(type) {
        document.querySelectorAll('.g-f-button-box[data-type="' + type + '"]').forEach(function(el) {
            el.style.display = 'none';
        });
    });
    document.querySelector('.i-m-p-wisdomhall-area').style.display = 'none';
    document.querySelectorAll('.i-m-p-c-a-c-l-course-box[data-course-id="399868"]').forEach(function(el) {
        el.style.display = 'none';
    });
    """
    // --- JS：暗黑模式樣式 ---
    let jsDarkMode = """
    document.lastElementChild.appendChild(document.createElement('style')).textContent = 'html {filter: invert(0.90) !important}';
    document.lastElementChild.appendChild(document.createElement('style')).textContent = 'video, img, div.image, div.s-i-t-b-wrapper, div.i-c-l-reload-button, div.g-f-button-box, div.i-a-c-q-t-q-b-top-box, div.button, div.i-r-reload-button, div.i-f-f-f-a-post-feedback-button, div.i-m-p-c-a-c-l-c-b-green-block, div.i-m-p-c-a-c-l-c-b-t-star, div.s-i-top-box, div.s-i-t-b-i-b-icon, div.p-m-c-icon-box, div.user-icon-switch, div.c-pm-c-chat-wrapper.message-box, div.c-pm-c-send-message, div.c-pm-c-receive-message, div.c-pm-c-r-text, div.c-pm-c-s-text, div.c-pm-c-r-icon, div.c-pm-c-r-redirect, div.c-pm-c-chat-topic-card-list, div.i-h-r-rollcall-row.i-h-r-r-r-nonarrival, div.i-h-r-rollcall-row.i-h-r-r-r-punctual {filter: invert(100%) !important;}';
    """
    
    // --- 系統是否為深色模式 ---
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        AppBar_Framework(title: "Zuvio") {
            ZStack {
                WebViewContainer(webView: WebZuvio.webView)
                    .opacity(WebZuvio.isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: WebZuvio.isVisible)

                ProgressOverlay(isVisible: $showOverlay, text: overlayText)
            }
            .onAppear {
                // 初始化狀態
                WebZuvio.setVisible(false)

                // 每次頁面載入完成都執行 hideElements
                WebZuvio.onPageFinished = { url in
                    // print("頁面載入完成: \(url ?? "未知網址")")
                    
                    // 1. 隱藏多餘元素
                    WebZuvio.evaluateJS(jsHideElements) { _ in
                        // 2. 如果是 Dark Mode，執行反白樣式
                        if colorScheme == .dark {
                            // print("啟用暗黑模式 JS")
                            WebZuvio.evaluateJS(jsDarkMode) { _ in
                                showPage()
                            }
                        } else {
                            showPage()
                        }
                    }
                }

                // 進度監聽（可顯示文字）
                WebZuvio.onProgressChanged = { progress in
                    overlayText = LocalizedStringKey("loading")
                    // overlayText = "載入中... \(Int(progress * 100))%"
                    WebZuvio.setVisible(false)
                    if progress < 1.0 {
                        showOverlay = true
                    }
                }
            }
        }
    }

    // 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility）
    private func showPage() {
        DispatchQueue.main.async {
            WebZuvio.setVisible(true)
            showOverlay = false
            // print("顯示頁面完成")
        }
    }

}
