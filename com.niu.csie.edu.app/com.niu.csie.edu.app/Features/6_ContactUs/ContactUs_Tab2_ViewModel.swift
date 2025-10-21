import SwiftUI
import Combine



@MainActor
final class ContactUs_Tab2_ViewModel: ObservableObject {
    
    // --- 狀態 ---
    
    
    // --- WebView 相關 ---
    let webProvider: WebView_Provider
    
    // --- JS：隱藏多餘元素 ---
    
    
    init() {
        self.webProvider = WebView_Provider(
            initialURL: "https://forms.gle/VtD6fdu5b2j82uL37",
            userAgent: .desktop
        )
    }
    
    // --- 初始化狀態 ---
    func initializeState() {
        webProvider.setVisible(true)
    }
    
}
