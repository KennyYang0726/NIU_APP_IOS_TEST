import SwiftUI



struct Drawer_QuestionnaireView: View {
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        NavigationStack {
            // MARK: - 說明卡片頁面
            ZStack {
                VStack {
                    VStack(spacing: isPad ? 24 : 16) {
                        Text(LocalizedStringKey("Satisfaction_Survey_Text"))
                            .font(.system(size: isPad ? 47 : 21))
                            .foregroundColor(Color("Text_Color"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 23)
                            .foregroundColor(Color("Linear_Inside"))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                    // 啟動問卷按鈕
                    NavigationLink {
                        WebQuestionnairePage()
                    } label: {
                        Text(LocalizedStringKey("Start_Satisfaction_Survey"))
                            .font(.system(size: isPad ? 47 : 21))
                            .padding(13)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .foregroundColor(Color("BG_Color"))
                            )
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, isPad ? 41 : 20)
                    .padding(.top, 40)

                    Spacer()
                }
            }
            .background(Color("Linear").ignoresSafeArea()) // 全域底色
        }
    }
}

// MARK: - 問卷 WebView 頁面
struct WebQuestionnairePage: View {
    @StateObject private var webProvider = WebView_Provider(
        initialURL: "https://forms.gle/vYGJN8sa884ntvWR9",
        userAgent: .mobile
    )

    var body: some View {
        WebViewContainer(webView: webProvider.webView).ignoresSafeArea(edges: .bottom)
        .navigationTitle(LocalizedStringKey("Satisfaction_Survey"))
        .toolbarBackground(.visible, for: .navigationBar) // 強制背景顯示
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
