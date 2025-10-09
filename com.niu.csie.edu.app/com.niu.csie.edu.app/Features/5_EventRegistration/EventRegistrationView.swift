import SwiftUI



struct EventRegistrationView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Event_Registration") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是活動報名頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
