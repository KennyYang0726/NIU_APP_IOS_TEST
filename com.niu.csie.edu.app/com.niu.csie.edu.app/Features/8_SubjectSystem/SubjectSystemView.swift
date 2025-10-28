import SwiftUI



struct SubjectSystemView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    @StateObject private var vm = SubjectSystemViewModel()
    
    public var body: some View {
        AppBar_Framework(title: "Subject_System") {
            ZStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .opacity(vm.isWebVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: vm.isWebVisible)
                    .ignoresSafeArea(edges: .bottom)

                ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
            }
            .onAppear {
                // 註冊 alert handler（ViewModel 已自動處理）
                vm.appState = appState
            }
        }
    }
}
