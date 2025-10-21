import SwiftUI
import Combine



@MainActor
final class EventRegistration_Tab1_ViewModel: ObservableObject {
    
    // --- 狀態 ---
    
    
    // --- WebView 相關 ---
    let webProvider: WebView_Provider
    
    // --- JS：隱藏多餘元素 ---
    
    
    init() {
        self.webProvider = WebView_Provider(
            initialURL: "https://ccsys.niu.edu.tw/MvcTeam/Act",
            userAgent: .desktop
        )
    }
    
    // --- 初始化狀態 ---
    func initializeState() {
        webProvider.setVisible(true)
    }
    
}
