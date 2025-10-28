//
//  Firebase、通知註冊
//
import UIKit
import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications



final class PushDiag {
    static func log(_ msg: String) { print("🔎 [Push] \(msg)") }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        FirebaseApp.configure()

        // 代理人
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        // 要求授權（授權成功才註冊 APNs，避免時序問題）
        requestNotificationPermission(application: application)

        // 主動抓一次 FCM Token（有時候 delegate 不會立刻回）
        Messaging.messaging().token { token, error in
            if let error = error {
                PushDiag.log("取得 FCM Token 失敗：\(error)")
            } else if let token = token {
                PushDiag.log("FCM Token（主動）：\(token)")
            } else {
                PushDiag.log("FCM Token 為 nil（免費簽名常見）")
            }
        }

        // 診斷：目前是否已註冊遠端通知
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            PushDiag.log("isRegisteredForRemoteNotifications = \(application.isRegisteredForRemoteNotifications)")
        }

        return true
    }

    private func requestNotificationPermission(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                PushDiag.log("通知授權錯誤：\(error)")
                return
            }
            PushDiag.log("通知授權授與：\(granted)")

            // 有授權再註冊 APNs
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }

    // MARK: - APNs 註冊結果
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        PushDiag.log("APNs Device Token：\(tokenString)")

        // 關鍵：把 APNs token 交給 FCM（之後付費並上傳 APNs Key 才能用）
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushDiag.log("註冊遠端通知失敗：\(error.localizedDescription)")
        #if targetEnvironment(simulator)
        PushDiag.log("（模擬器不支援推播，請用真機）")
        #endif
    }

    // MARK: - FCM Token 更新
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            PushDiag.log("FCM Token（delegate）：\(fcmToken)")
            // 之後可在此上傳到你的後端
        } else {
            PushDiag.log("FCM Token（delegate）為 nil")
        }
    }

    // MARK: - 前景通知呈現
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - 點擊通知/背景抓取（處理 data-only 或導航）
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushDiag.log("收到遠端通知 payload：\(userInfo)")
        completionHandler(.newData)
    }
}


/*
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        requestNotificationPermission(application: application)

        return true
    }

    private func requestNotificationPermission(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("通知權限錯誤：\(error)")
            } else {
                print("通知權限授權：\(granted)")
            }
        }

        application.registerForRemoteNotifications()
    }

    // MARK: - FCM Token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM Token: \(fcmToken)")
    }
    

    // MARK: - 通知處理
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
*/

