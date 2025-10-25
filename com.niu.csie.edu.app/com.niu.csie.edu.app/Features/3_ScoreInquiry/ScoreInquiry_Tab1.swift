import SwiftUI


// 活動列表
struct ScoreInquiry_Tab1: View {
    
    @ObservedObject var vm = ScoreInquiry_Tab1_ViewModel()
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        ScrollView {
            VStack {
                WebViewContainer(webView: vm.webProvider.webView)
                    .ignoresSafeArea(edges: .bottom)
                /*
                Text("Tab 01")
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
