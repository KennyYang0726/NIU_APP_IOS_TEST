// AppState.swift
import SwiftUI



enum AppRoute {
    case login
    case home
    // Home 的功能頁
    case EUNI                 // M園區
    case Score_Inquiry        // 成績查詢
    case Class_Schedule       // 我的課表
    case Event_Registration   // 活動報名
    case Contact_Us           // 聯絡我們
    case Graduation_Threshold // 畢業門檻
    case Subject_System       // 選課系統
    case Bus                  // 公車動態
    case ZUVIO                // ZUVIO
    case Take_Leave           // 請假系統
    case Mail                 // 校園信箱
}

class AppState: ObservableObject {
    @Published var route: AppRoute = .login // 設定初始畫面為 login
    @Published var toastMessage: LocalizedStringKey? = nil
    
    func navigate(to route: AppRoute, withToast message: LocalizedStringKey? = nil) {
        if let msg = message {
            toastMessage = msg // 跳頁 + show Toast
        }
        self.route = route // 提供簡單的跳頁方法
    }
}
