//
//  Firebase、通知註冊
//
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications



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
        // debug
        DispatchQueue.main.async {
            self.showTokenAlert(fcmToken)
        }
    }
    

    
    private func showTokenAlert(_ token: String) {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "FCM Token",
            message: token,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = token
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        rootVC.present(alert, animated: true)
    }

    
    
    // MARK: - 通知處理
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}


