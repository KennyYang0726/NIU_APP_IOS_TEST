import SwiftUI


// 我的報名
struct ScoreInquiry_Tab2: View {
    
    @ObservedObject var vm = ScoreInquiry_Tab2_ViewModel()
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ScrollView {
            VStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .ignoresSafeArea(edges: .bottom)
                /*
                Text("Tab 02")
                    .font(.largeTitle)
                    .bold()
                Spacer()*/
            }
            .padding(isPad ? 40 : 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}
