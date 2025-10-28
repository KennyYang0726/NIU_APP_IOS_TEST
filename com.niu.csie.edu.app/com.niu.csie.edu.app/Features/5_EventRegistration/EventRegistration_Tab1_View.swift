import SwiftUI


// 活動列表
struct EventRegistration_Tab1_View: View {
    
    @ObservedObject var vm = EventRegistration_Tab1_ViewModel()

    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.events) { event in
                            let itemVM = EventRegistration_Tab1_ListViewModel(event: event)
                            EventRegistration_Tab1_ListView(vm: itemVM, onDetailTapped: { e in
                                vm.showEventDetailDialog = true
                                vm.selectedEventForDetail = e
                                })
                        }
                    }
                    .padding(.top, 10)
                }
                // 移出畫面外的 Webview
                ZStack {
                    WebViewContainer(webView: vm.webProvider.webView)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .offset(x: UIScreen.main.bounds.width * 2)
                }
            }
        }
        // 加載中 prog (注意！放在這裡才是全版面)
        .overlay(
            ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}
