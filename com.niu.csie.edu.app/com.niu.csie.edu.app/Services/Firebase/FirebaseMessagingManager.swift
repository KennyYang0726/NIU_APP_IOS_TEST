import FirebaseMessaging
import UserNotifications



final class FirebaseMessagingManager {
    static let shared = FirebaseMessagingManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    print("通知授權狀態：\(granted)")
                }
            } else {
                print("現有通知狀態：\(settings.authorizationStatus.rawValue)")
            }
        }
    }
}
