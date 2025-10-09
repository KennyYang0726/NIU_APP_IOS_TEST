import SwiftUI



struct GraduationThresholdView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "Graduation_Threshold") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是畢業門檻頁面")
                    .font(.title3)
                Text("wwwwwwww")
                    .font(.body)
            }
        }
    }
}
