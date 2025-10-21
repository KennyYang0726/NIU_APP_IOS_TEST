import SwiftUI



struct TakeLeaveView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject private var vm = TakeLeaveViewModel()
    
    var body: some View {
        AppBar_Framework(title: "Take_Leave") {
            ZStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .opacity(vm.isWebVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: vm.isWebVisible)
                    .ignoresSafeArea(edges: .bottom)
                
                ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
            }
            .onAppear {
                vm.loadInitialPage()
            }
        }
    }
}
