import SwiftUI



struct ClassScheduleView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Class_Schedule") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是課表查詢頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
