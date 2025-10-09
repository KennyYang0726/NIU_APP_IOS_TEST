import SwiftUI



struct ContactUsView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Contact_Us") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是聯絡我們頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
