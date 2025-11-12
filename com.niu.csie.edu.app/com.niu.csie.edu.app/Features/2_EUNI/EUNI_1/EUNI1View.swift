import SwiftUI



struct EUNI1View: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    @ObservedObject var vm = EUNI1ViewModel()
    
    public var body: some View {
        AppBar_Framework(title: "EUNI") {
            VStack {
                ZStack {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(vm.courseList) { courseVM in
                                EUNI1_ListView(vm: courseVM)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .toast(isPresented: $vm.showToast) {
                        Text(LocalizedStringKey("EUNI_Course_Load_Success_Toast"))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(12)
                    }
                    // 移出畫面外的 Webview
                    ZStack {
                        WebViewContainer(webView: vm.webProvider.webView)
                            //.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(maxWidth: 100, maxHeight: 100)
                            .offset(x: UIScreen.main.bounds.width * 2)
                    }
                }
            }
            // 加載中 prog (注意！放在這裡才是全版面)
            .overlay(
                ProgressOverlay(isVisible: $vm.isOverlayVisible, text: vm.overlayText)
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            vm.isRefreshing.toggle()
                        }
                        vm.reloadWebAndFetch()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation {
                                vm.isRefreshing.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(vm.isRefreshing ? 360 : 0))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color("Linear").ignoresSafeArea()) // 全域底色
        }
    }
}
