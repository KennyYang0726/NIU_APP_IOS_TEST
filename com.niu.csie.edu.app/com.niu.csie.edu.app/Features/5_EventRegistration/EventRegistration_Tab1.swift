import SwiftUI


// 活動列表
struct EventRegistration_Tab1: View {
    
    @ObservedObject var vm = EventRegistration_Tab1_ViewModel()

    var body: some View {
        VStack {
            WebViewContainer(webView: vm.webProvider.webView)
                .ignoresSafeArea(edges: .bottom)
            /*
            Text("Tab 01")
                .font(.largeTitle)
                .bold()
            Spacer()*/
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}
