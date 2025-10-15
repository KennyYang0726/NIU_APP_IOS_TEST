import Foundation
import FirebaseDatabase



final class FirebaseDatabaseManager {
    static let shared = FirebaseDatabaseManager()
    private let ref = Database.database().reference()

    private init() {}

    func ensureUserNodeExists(for studentId: String, name: String) {
        let userRef = ref.child("users").child(studentId)
        userRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("使用者節點已存在：users/\(studentId)")
            } else {
                print("建立新使用者節點：users/\(studentId)")
                self.createNewUserNode(for: studentId, name: name)
            }
        }
    }

    // MARK: - 建立新節點
    private func createNewUserNode(for studentId: String, name: String) {
        TimeService.shared.fetchTaipeiDate { dateString in
            guard let dateString = dateString else {
                print("⚠️ 取得台北時間失敗，改用本機時間")
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
                let fallback = formatter.string(from: Date())
                self.createNode(for: studentId, name: name, date: fallback)
                return
            }
            self.createNode(for: studentId, name: name, date: dateString)
        }
    }

    // MARK: - 寫入 Firebase
    private func createNode(for studentId: String, name: String, date: String) {
        let defaultData: [String: Any] = [
            "Name": processName(name),
            "First_Login_IOS": true,
            "Achievements": [
                "01": true,
                "02": false,
                "03": false,
                "04": false,
                "05": false,
                "06": false,
                "07": false,
                "08": false,
                "09": false,
                "10": false,
                "11": "00000000000000",
                "首次登入日期": date
            ]
        ]

        ref.child("users").child(studentId).setValue(defaultData) { error, _ in
            if let error = error {
                print("建立使用者節點失敗：\(error)")
            } else {
                print("使用者節點建立成功：users/\(studentId)")
            }
        }
    }
    
    // MARK: - 通用讀取資料方法
    func readData(from path: String, completion: @escaping (Any?) -> Void) {
        // 以「/」分割節點，支援像 "app/ver" 這種格式
        let nodes = path.split(separator: "/").map { String($0) }
        var currentRef = ref

        for node in nodes {
            currentRef = currentRef.child(node)
        }

        currentRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(snapshot.value)
            } else {
                print("⚠️ 找不到節點：\(path)")
                completion(nil)
            }
        }
    }
    
    // 處理姓名
    func processName(_ name: String) -> String {
        let length = name.count

        if length == 2 {
            let first = name.first!
            return "\(first)○"
        } else if length > 2 {
            let first = name.first!
            let last = name.last!
            let middle = String(repeating: "○", count: length - 2)
            return "\(first)\(middle)\(last)"
        } else {
            // 只有一個字就原樣返回
            return name
        }
    }
    
}
