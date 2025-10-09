import SwiftUI



struct SubjectSystemView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Subject_System") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是選課系統頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
