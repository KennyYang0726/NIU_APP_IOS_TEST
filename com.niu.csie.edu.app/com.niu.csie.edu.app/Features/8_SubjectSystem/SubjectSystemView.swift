import SwiftUI



struct SubjectSystemView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    @StateObject private var WebSubjectSystem = WebView_Provider(
        initialURL: "about:blank",
        userAgent: .desktop
    )
    
    @State private var showOverlay = true
    @State private var overlayText: LocalizedStringKey = "loading"
    // @State private var overlayText = "載入中..."
    
    let sso = SSOIDSettings.shared
    
    
    public var body: some View {
        AppBar_Framework(title: "Subject_System") {
            ZStack {
                WebViewContainer(webView: WebSubjectSystem.webView)
                    .opacity(WebSubjectSystem.isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: WebSubjectSystem.isVisible)
                    .ignoresSafeArea(edges: .bottom)

                ProgressOverlay(isVisible: $showOverlay, text: overlayText)
            }
            .onAppear {
                // 註冊 alert handler
                WebSubjectSystem.onJsAlert = { message in
                    if message.contains("選課期間") {
                        print("onAlert 收到：\(message)")
                        appState.navigate(to: .home, withToast: LocalizedStringKey("currently_not_a_course_selection_time"))
                    }
                }

                // 載入頁面
                let fullURL = "https://ccsys.niu.edu.tw/SSO/" + sso.acade_subject_system
                WebSubjectSystem.load(url: fullURL)
            }
        }
    }
    
    
    // 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility）
    private func showPage() {
        DispatchQueue.main.async {
            WebSubjectSystem.setVisible(true)
            showOverlay = false
            // print("顯示頁面完成")
        }
    }
}
