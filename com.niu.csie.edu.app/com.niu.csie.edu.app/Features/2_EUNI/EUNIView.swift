import SwiftUI



struct EUNIView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    @StateObject private var WebEUNI = WebView_Provider(
        initialURL: "about:blank",
        userAgent: .desktop
    )
    
    @State private var showOverlay = true
    @State private var overlayText: LocalizedStringKey = "loading"
    // @State private var overlayText = "載入中..."
    
    let sso = SSOIDSettings.shared
    
    
    public var body: some View {
        AppBar_Framework(title: "EUNI") {
            ZStack {
                WebViewContainer(webView: WebEUNI.webView)
                    .opacity(WebEUNI.isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: WebEUNI.isVisible)
                    .ignoresSafeArea(edges: .bottom)

                ProgressOverlay(isVisible: $showOverlay, text: overlayText)
            }
            .onAppear {
                // 初始化狀態
                WebEUNI.setVisible(false)
                let fullURL = "https://ccsys.niu.edu.tw/SSO/" + sso.EUNI
                WebEUNI.load(url: fullURL)
                WebEUNI.onPageFinished = { url in
                    
                }
                
                // 進度監聽（可顯示文字）
                WebEUNI.onProgressChanged = { progress in
                    overlayText = LocalizedStringKey("loading")
                    // overlayText = "載入中... \(Int(progress * 100))%"
                    WebEUNI.setVisible(false)
                    if progress < 1.0 {
                        showOverlay = true
                    } else {
                        showPage()
                    }
                }
            }
            
        }
    }
    
    // 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility）
    private func showPage() {
        DispatchQueue.main.async {
            WebEUNI.setVisible(true)
            showOverlay = false
            // print("顯示頁面完成")
        }
    }
    
}
