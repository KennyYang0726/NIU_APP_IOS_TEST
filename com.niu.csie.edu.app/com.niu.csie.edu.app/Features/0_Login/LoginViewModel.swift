import Foundation
import SwiftUI
import Combine


/// MVVM: 負責「狀態」與「業務邏輯」

// 由於 alert 在 view 只能實例1次，使用 case 區別
enum LoginAlert: Identifiable {
    case emptyFields
    case loginFailed
    var id: Int { hashValue }
}

final class LoginViewModel: ObservableObject {
    
    private let repository = LoginRepository()
    
    // MARK: - 使用者輸入 & UI 狀態
    @Published var account: String = ""          // 帳號
    @Published var password: String = ""         // 密碼
    @Published var isPasswordVisible: Bool = false
    
    // 告訴 view 此時的 alert case
    @Published var LoginActiveAlert: LoginAlert?
    
    @Published var showSuccessToast = false      // 登入成功提示
    @Published var startLoginProcess = false     // 開始登入流程
    
    // 登入狀態
    @Published var zuvioLoginSuccess = false
    @Published var ssoLoginSuccess = false
    @Published var loginFinished = false
    
    // prog
    @Published var showOverlay: Bool = false
    @Published var overlayText: LocalizedStringKey = "logining"
    
    // MARK: - 衍生屬性
    /// 轉換輸入帳號成 Zuvio 登入帳號
    var zuvioLoginEmail: String {
        let idPart = account.split(separator: "@").first ?? ""
        return "\(idPart)@ms.niu.edu.tw"
    }

    /// 轉換輸入帳號成 SSO 登入帳號
    var loginAccount: String {
        return account.split(separator: "@").first.map(String.init) ?? ""
    }
    
    // MARK: - 動作事件（由 View 呼叫）
    func onTapLogin() {
        guard !account.isEmpty, !password.isEmpty else {
            LoginActiveAlert = .emptyFields
            return
        }
        // 顯示 prog
        showOverlay = true
        // 重置狀態，避免殘留影響這次流程
        showSuccessToast = false
        zuvioLoginSuccess = false
        loginFinished = false
        startLoginProcess = true
    }
    
    func autoLogin() {
        if let saved = repository.loadCredentials() {
            account = saved.username
            password = saved.password
            // 顯示 prog
            showOverlay = true
            // 重置狀態，避免殘留影響這次流程
            showSuccessToast = false
            zuvioLoginSuccess = false
            loginFinished = false
            startLoginProcess = true
        }
    }
    
    func handleLoginResult(_ success: Bool) {
        // 統一收斂成功/失敗結果
        startLoginProcess = false
        loginFinished = true
        zuvioLoginSuccess = success
        // 隱藏 prog
        showOverlay = false
        if success {
            // 紀錄帳密
            repository.saveCredentials(username: account, password: password)
            // 通知改變結果
            showSuccessToast = true
        } else {
            // 刪除帳密
            repository.clearCredentials()
            // 通知改變結果
            LoginActiveAlert = .loginFailed
        }
    }
    
    func togglePasswordVisible() {
        isPasswordVisible.toggle()
    }
}
