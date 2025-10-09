import Foundation
import SwiftUI
import Combine


/// MVVM: 負責「狀態」與「業務邏輯」

// 由於 alert 在 view 只能實例1次，使用 case 區別
enum LoginAlert_Home: Identifiable {
    case emptyFields
    case loginFailed
    var id: Int { hashValue }
}

final class HomeViewModel: ObservableObject {
    
    
    
}
