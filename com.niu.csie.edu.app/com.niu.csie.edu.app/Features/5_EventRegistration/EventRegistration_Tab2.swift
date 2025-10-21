import SwiftUI


// 我的報名
struct EventRegistration_Tab2: View {
    
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
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}
