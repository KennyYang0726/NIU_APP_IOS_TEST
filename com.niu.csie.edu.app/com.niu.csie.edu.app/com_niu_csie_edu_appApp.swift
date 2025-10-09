//
//  com_niu_csie_edu_appApp.swift
//  com.niu.csie.edu.app
//
//  指定 app 進入點
//

import SwiftUI

@main
struct com_niu_csie_edu_appApp: App {
    
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .preferredColorScheme(resolveColorScheme(settings.theme)) // 即時反映設定改變
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
