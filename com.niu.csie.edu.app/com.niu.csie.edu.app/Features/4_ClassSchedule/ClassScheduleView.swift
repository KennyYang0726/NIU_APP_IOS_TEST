import SwiftUI



struct ClassScheduleView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var vm = ClassScheduleViewModel()
    
    var body: some View {
        AppBar_Framework(title: "Class_Schedule") {
            ZStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .opacity(vm.isWebVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: vm.isWebVisible)
                    .ignoresSafeArea(edges: .bottom)
                
                ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
            }
            .onAppear {
                // 初始化狀態
                vm.InitialSettings()
                vm.colorScheme = colorScheme
            }
        }
    }
}
