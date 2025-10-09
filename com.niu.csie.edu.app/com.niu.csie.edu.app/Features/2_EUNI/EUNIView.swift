import SwiftUI



struct EUNIView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    public var body: some View {
        AppBar_Framework(title: "EUNI") {
            VStack(alignment: .leading, spacing: 16) {
                Text("這裡是EUNI頁面")
                    .font(.title3)
                Text("BALABALABALA")
                    .font(.body)
            }
        }
    }
}
