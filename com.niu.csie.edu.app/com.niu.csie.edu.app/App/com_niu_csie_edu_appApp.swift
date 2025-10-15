//
//  com_niu_csie_edu_appApp.swift
//  com.niu.csie.edu.app
//
//  指定 app 進入點
//

import SwiftUI

@main
struct com_niu_csie_edu_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settings = AppSettings()
    @StateObject private var session = SessionManager()      // ⬅️ 新增

    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(session)                  // ⬅️ 注入
                .preferredColorScheme(resolveColorScheme(settings.theme)) // 即時反映設定改變
                .onAppear {
                    // App 啟動後先執行匿名登入
                    FirebaseAuthManager.shared.signInAnonymously()
                }
            // LoginView()
            // DrawerManagerView()
        }
    }
    
    //
    private func resolveColorScheme(_ theme: AppTheme) -> ColorScheme? {
        switch theme {
            case .default:
                return nil
            case .bright:
                return .light
            case .dark:
                return .dark
        }
    }
}
