import SwiftUI



struct ScoreInquiryView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Score_Inquiry") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是成績查詢頁面")
                    .font(.title3)
                Text("你可以在這裡放置成績列表、查詢表單或其他 UI。")
                    .font(.body)
            }
        }
    }
}
