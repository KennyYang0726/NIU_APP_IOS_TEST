import Foundation
import SwiftUI
import Combine
import FirebaseAuth


/// MVVM: 負責「狀態」與「業務邏輯」

// 由於 alert 在 view 只能實例1次，使用 case 區別
enum LoginAlert_Home: Identifiable {
    case emptyFields
    case loginFailed
    var id: Int { hashValue }
}

final class HomeViewModel: ObservableObject {
    
    @Published var isLoggingOut = false
    
    // 標誌位，判斷分別登出 js 是否執行完成
    @Published var SSO_Login = true
    @Published var Zuvio_Login = true
    
    // progress overlay
    @Published var showOverlay: Bool = false
    @Published var overlayText: LocalizedStringKey = "logouting"

    private let loginRepo = LoginRepository()
    private let appSettings: AppSettings
    
    let SSO_Logout_JS = """
    (function() {
        var btn = document.querySelector('.btn-logout');
        if (btn) { 
            btn.click(); 
            return 'clicked'; 
        } else { 
            return 'not found'; 
        }
    })();
    """
    private let Zuvio_Logout_JS = "setting_logout();"

    init(appSettings: AppSettings) {
        self.appSettings = appSettings
        if Auth.auth().currentUser != nil { // 若匿名登入成功
            FirebaseDatabaseManager.shared.ensureUserNodeExists(for: loginRepo.loadCredentials()!.username, name: appSettings.name)
            }
    }
    
    // 登出主流程
    func logout(zuvioWeb: WebView_Provider, ssoWeb: WebView_Provider) {
        // prog show
        showOverlay = true

        // 執行兩個 WebView 的登出 JS
        zuvioWeb.evaluateJS(Zuvio_Logout_JS) { result in
            zuvioWeb.clearCache()
            self.Zuvio_Login = false
        }
        ssoWeb.evaluateJS(SSO_Logout_JS) { result in
            ssoWeb.clearCache()
            self.SSO_Login = false
        }

        // 清空帳密
        loginRepo.clearCredentials()
        // 清空姓名
        appSettings.name = ""
    }
}
