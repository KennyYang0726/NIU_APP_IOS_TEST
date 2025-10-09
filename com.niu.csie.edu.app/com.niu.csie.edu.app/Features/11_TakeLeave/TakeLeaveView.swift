import SwiftUI



struct TakeLeaveView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Take_Leave") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是請假系統頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
