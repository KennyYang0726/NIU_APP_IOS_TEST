import Foundation
import SwiftUI
import Combine


// ViewModel 控制狀態
final class DrawerManagerViewModel: ObservableObject {

    @Published var isDrawerOpen = false
    @Published var currentPage: DrawerPageCase = .home
    
    // 外部注入 callback：由 HomeViewModel 提供
    var onLogout: (() -> Void)?
    
    func switchPage(to page: DrawerPageCase) {
        withAnimation {
            currentPage = page
            isDrawerOpen = false
        }
    }
    
    func toggleDrawer() {
        withAnimation {
            isDrawerOpen.toggle()
        }
    }
    
    func closeDrawer() {
        withAnimation {
            isDrawerOpen = false
        }
    }
    
    func performLogout() {
        withAnimation { isDrawerOpen = false }
        onLogout?()  // 交由上層（HomeViewModel）處理
    }
}
