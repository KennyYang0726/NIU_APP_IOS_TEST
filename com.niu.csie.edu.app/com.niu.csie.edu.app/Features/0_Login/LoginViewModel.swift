import Foundation
import SwiftUI
import Combine

/// MVVM: 負責「狀態」與「業務邏輯」

// MARK: - Alert 狀態枚舉
enum LoginAlert: Identifiable {
    // 基本登入
    case emptyFields
    case loginFailed

    // === SSO 專用 ===
    case ssoCredentialsFailed(message: String)          // 帳密錯誤
    case ssoPasswordExpiring(message: String)           // 密碼即將到期（SweetAlert）
    case ssoPasswordExpired(message: String)            // 密碼已到期（SweetAlert）
    case ssoAccountLocked(lockTime: String?)            // 帳號鎖定
    case ssoSystemError                                 // error.html
    case ssoGeneric(title: String, message: String)     // 其他通用訊息

    var id: String {
        switch self {
        case .emptyFields: return "emptyFields"
        case .loginFailed: return "loginFailed"
        case .ssoCredentialsFailed(let m): return "ssoCredentialsFailed:\(m)"
        case .ssoPasswordExpiring(let m): return "ssoPasswordExpiring:\(m)"
        case .ssoPasswordExpired(let m): return "ssoPasswordExpired:\(m)"
        case .ssoAccountLocked(let t): return "ssoAccountLocked:\(t ?? "")"
        case .ssoSystemError: return "ssoSystemError"
        case .ssoGeneric(let t, let m): return "ssoGeneric:\(t)|\(m)"
        }
    }
}

// MARK: - ViewModel 主體
final class LoginViewModel: ObservableObject {

    private let repository = LoginRepository()

    // MARK: - 使用者輸入 & UI 狀態
    @Published var account: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // MARK: - Alert 狀態
    @Published var LoginActiveAlert: LoginAlert?

    // MARK: - 登入狀態與流程
    @Published var startZuvioLoginProcess = false
    @Published var startSSOLoginProcess = false

    @Published var zuvioLoginSuccess = false
    @Published var ssoLoginSuccess = false
    @Published var loginFinished = false

    // progress overlay
    @Published var showOverlay: Bool = false
    @Published var overlayText: LocalizedStringKey = "logining"

    // SweetAlert 關閉後續（由 WebView 帶回）
    var resumeSSOAfterClosingSweetAlert: (() -> Void)?

    init() {
        // 預設行為：稍後再說 → 0.5 秒後重新開始 SSO 登入流程
        self.resumeSSOAfterClosingSweetAlert = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startSSOLoginProcess = true
            }
        }
    }

    // MARK: - 衍生屬性
    var zuvioLoginEmail: String {
        let idPart = account.split(separator: "@").first ?? ""
        return "\(idPart)@ms.niu.edu.tw"
    }

    var loginAccount: String {
        return account.split(separator: "@").first.map(String.init) ?? ""
    }

    // MARK: - 動作事件
    func onTapLogin() {
        guard !account.isEmpty, !password.isEmpty else {
            LoginActiveAlert = .emptyFields
            return
        }
        showOverlay = true
        zuvioLoginSuccess = false
        ssoLoginSuccess = false
        loginFinished = false
        startZuvioLoginProcess = true
        startSSOLoginProcess = true
    }

    func autoLogin() {
        if let saved = repository.loadCredentials() {
            account = saved.username
            password = saved.password
            showOverlay = true
            zuvioLoginSuccess = false
            ssoLoginSuccess = false
            loginFinished = false
            startZuvioLoginProcess = true
            startSSOLoginProcess = true
        }
    }

    func handleZuvioLoginResult(_ success: Bool) {
        startZuvioLoginProcess = false
        zuvioLoginSuccess = success
        checkLoginResult()
    }

    func handleSSOLoginResult(_ result: SSOLoginResult) {
        startSSOLoginProcess = false
        
        switch result {
        case .success:
            ssoLoginSuccess = true
            checkLoginResult()
        case .credentialsFailed(let message):
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoCredentialsFailed(message: message)
            checkLoginResult()
        case .passwordExpiring(let message):
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoPasswordExpiring(message: message)
            checkLoginResult()
        case .passwordExpired(let message):
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoPasswordExpired(message: message)
            checkLoginResult()
        case .accountLocked(let lockTime):
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoAccountLocked(lockTime: lockTime)
            checkLoginResult()
        case .systemError:
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoSystemError
            checkLoginResult()
        case .generic(let title, let message):
            ssoLoginSuccess = false
            LoginActiveAlert = .ssoGeneric(title: title, message: message)
            checkLoginResult()
        case .captchaError:
            // 驗證碼錯誤，重新開始登入流程
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.startSSOLoginProcess = true
            }
        }
    }

    private func checkLoginResult() {
        // 當兩邊都完成才收斂
        
        print("--------")
        print("startZuvioLoginProcess:\(startZuvioLoginProcess)")
        print("zuvioLoginSuccess:\(zuvioLoginSuccess)")
        print("startSSOLoginProcess:\(startSSOLoginProcess)")
        print("ssoLoginSuccess:\(ssoLoginSuccess)")
        print("--------")
        
        guard !startZuvioLoginProcess, !startSSOLoginProcess else { return }

        showOverlay = false
        loginFinished = true

        if zuvioLoginSuccess && ssoLoginSuccess {
            // 記錄帳密 (強制轉大寫)
            repository.saveCredentials(username: account.uppercased(), password: password)
        } else {
            // 清除帳密記錄
            repository.clearCredentials()
            // 只有在沒有其他 Alert 顯示時才顯示登入失敗
            // (不會觸發，因為SSO帳密錯誤或到期必定跳Dialog，以 sso dialog 為主)
            /*
            if LoginActiveAlert == nil {
                LoginActiveAlert = .loginFailed
            }*/
        }
    }

    func togglePasswordVisible() {
        isPasswordVisible.toggle()
    }

    // MARK: - 開啟修改密碼頁
    func openSSOPasswordChange() {
        guard let url = URL(string: "https://ccsys.niu.edu.tw/SSO/Teac_Secret.aspx") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        startSSOLoginProcess = false
        /*
        // 延遲一點點後結束 App（避免使用者還沒切出去就被關掉）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.terminateApp()
        }*/
    }
    /*
    private func terminateApp() {
        // ⚠️ Apple 不建議直接關閉 App，但技術上可以這樣做：
        // apple 人工審查階段可能被拒
        exit(0)
    }*/
}



extension LoginViewModel {
    /// 回到 Login 畫面或準備新的登入嘗試時，先把流程狀態清掉
    func resetForFreshAttempt() {
        showOverlay = false
        zuvioLoginSuccess = false
        ssoLoginSuccess = false
        loginFinished = false
        startZuvioLoginProcess = false
        startSSOLoginProcess = false
        // 若有使用 Alert 狀態，也建議清一下，避免殘留：
        // LoginActiveAlert = nil
    }
}

