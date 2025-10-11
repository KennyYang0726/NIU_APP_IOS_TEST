import SwiftUI



enum AppTheme: String, CaseIterable {
    case `default`
    case bright
    case dark
}

// 儲存帳密的部分在 Features/0_Login/LoginRepository.swift
class AppSettings: ObservableObject {
    
    // 儲存 學年度 名字
    private let infoPrefs = UserDefaults(suiteName: "Infos")!
    // 儲存 使用者選擇的 主題色
    private let themePrefs = UserDefaults(suiteName: "AppThemePrefs")!
    
    @Published var theme: AppTheme {
        didSet { themePrefs.set(theme.rawValue, forKey: "theme") }
    }
    /*@Published var username: String {
        didSet { loginPrefs.set(username, forKey: "username") }
    }
    @Published var password: String {
        didSet { loginPrefs.set(password, forKey: "password") }
    }*/

    init() {
        // 檢查是否已有主題設定
        if let savedTheme = themePrefs.string(forKey: "theme"),
           let loadedTheme = AppTheme(rawValue: savedTheme) {
            self.theme = loadedTheme
        } else {
            // 初次啟動：沒有 KEY → 寫入 default
            self.theme = .default
            themePrefs.set(AppTheme.default.rawValue, forKey: "theme")
        }
        // --- 初始化帳密 ---
        // self.username = loginPrefs.string(forKey: "username") ?? ""
        // self.password = loginPrefs.string(forKey: "password") ?? ""
    }
}
