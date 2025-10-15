import SwiftUI



struct BusView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var vm = BusViewModel()
    
    public var body: some View {
        AppBar_Framework(title: "Bus") {
            ZStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .opacity(vm.isWebVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: vm.isWebVisible)
                    .ignoresSafeArea(edges: .bottom)
                        
                ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
            }
            .onAppear {
                // 初始化狀態
                vm.initializeState()
                vm.colorScheme = colorScheme
            }
        }
    }
}
