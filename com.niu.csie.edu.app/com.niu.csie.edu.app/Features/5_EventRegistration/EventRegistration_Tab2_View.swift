import SwiftUI


// 我的報名
struct EventRegistration_Tab2_View: View {
    
    @ObservedObject var vm = EventRegistration_Tab2_ViewModel()

    var body: some View {
        VStack {
            WebViewContainer(webView: vm.webProvider.webView)
                .ignoresSafeArea(edges: .bottom)
            /*
            Text("Tab 02")
                .font(.largeTitle)
                .bold()
            Spacer()*/
        }
        // 加載中 prog (注意！放在這裡才是全版面)
        .overlay(
            ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}
