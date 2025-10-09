import SwiftUI

// MARK: - 資料模型
struct HomeFeature: Identifiable {
    let id = UUID()
    let KeyIndex: Int              // 用來程式判斷 (case 不能用 localize 字串)
    let title: LocalizedStringKey  // UI 顯示 (可本地化)
    let iconName: String
    let isSystemIcon: Bool
}

let defaultFeatures: [HomeFeature] = [
    .init(KeyIndex: 0, title: "EUNI", iconName: "\u{e809}", isSystemIcon: false),
    .init(KeyIndex: 1, title: "Score_Inquiry", iconName: "\u{e801}", isSystemIcon: false),
    .init(KeyIndex: 2, title: "Class_Schedule", iconName: "\u{e803}", isSystemIcon: false),
    .init(KeyIndex: 3, title: "Event_Registration", iconName: "\u{e80a}", isSystemIcon: false),
    .init(KeyIndex: 4, title: "Contact_Us", iconName: "\u{e800}", isSystemIcon: false),
    .init(KeyIndex: 5, title: "Graduation_Threshold", iconName: "\u{e802}", isSystemIcon: false),
    .init(KeyIndex: 6, title: "Subject_System", iconName: "\u{e807}", isSystemIcon: false),
    .init(KeyIndex: 7, title: "Bus", iconName: "\u{e806}", isSystemIcon: false),
    .init(KeyIndex: 8, title: "Zuvio",  iconName: "\u{e804}", isSystemIcon: false),
    // 用 SF Symbols
    .init(KeyIndex: 9, title: "Take_Leave", iconName: "person.fill.xmark", isSystemIcon: true)
    // .init(KeyIndex: 10, title: "Mail",  iconName: "\u{e808}", isSystemIcon: false)
]


// MARK: - HomeView
struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @ObservedObject var drawerVM: DrawerManagerViewModel
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    @EnvironmentObject var appState: AppState // 注入狀態

    private let title = "首頁"

    // 固定三欄
    private var columns: [GridItem] {
        [GridItem(.flexible(), spacing: 20),
         GridItem(.flexible(), spacing: 20),
         GridItem(.flexible(), spacing: 20)]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color("Linear")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // ScrollView 內容
                    ScrollView {
                        VStack(spacing: 32) {
                            LazyVGrid(columns: columns,
                                      alignment: .center,
                                      spacing: hSizeClass == .regular ? 28 : 20) {
                                ForEach(defaultFeatures) { feature in
                                    FeatureItemView(feature: feature,
                                                    isPad: hSizeClass == .regular)
                                    .contentShape(Rectangle())
                                    // 新增點擊事件
                                    .onTapGesture {
                                        if let route = route(for: feature.KeyIndex) {
                                            appState.navigate(to: route)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                            
                            // 這裡放一個 Spacer，佔據和底圖一樣的高度
                            GeometryReader { proxy in
                                Color.clear
                                    .frame(height: proxy.size.height)
                            }
                            .frame(height: 0) // 不要影響 ScrollView 高度
                            
                            // 測試
                        
                            
                        }
                    }
                    
                    // 底部圖片
                    Image("NIU_background")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, hSizeClass == .regular ? -67 : -37) // 負數往下推
                }
            }
            .navigationTitle(title)
            .toolbarBackground(.visible, for: .navigationBar) // 強制背景顯示
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline) // 固定使用小標題樣式
        }
    }
    

    // 把 Home 的標題字串對應到 AppRoute
    private func route(for keyIndex: Int) -> AppRoute? {
        switch keyIndex {
        case 0:     return .EUNI
        case 1:     return .Score_Inquiry
        case 2:     return .Class_Schedule
        case 3:     return .Event_Registration
        case 4:     return .Contact_Us
        case 5:     return .Graduation_Threshold
        case 6:     return .Subject_System
        case 7:     return .Bus
        case 8:     return .ZUVIO
        case 9:     return .Take_Leave
        case 10:    return .Mail
        default:    return nil
        }
    }
}

// MARK: - 功能 Item
private struct FeatureItemView: View {
    let feature: HomeFeature
    let isPad: Bool

    var body: some View {
        VStack(spacing: isPad ? 12 : 8) {
            ZStack {
                Circle()
                    .strokeBorder(Color("HomeItemCircle"), lineWidth: isPad ? 3 : 2)
                    .frame(width: isPad ? 110 : 70, height: isPad ? 110 : 70)
                // 若是系統圖片
                if feature.isSystemIcon {
                    // 內建 SF Symbols
                    Image(systemName: feature.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: isPad ? 55 : 28, height: isPad ? 55 : 31)
                        .foregroundStyle(.primary)
                } else {
                    // TTF 自訂圖示
                        Text(feature.iconName) // 這裡使用 Text
                            .font(.custom("MyFlutterApp", size: isPad ? 61 : 37))
                            .foregroundStyle(.primary)
                    }
            }

            Text(feature.title)
                .font(.system(size: isPad ? 29 : 17, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity, minHeight: isPad ? 160 : 110)
        .contentShape(Rectangle())
        .padding(.vertical, isPad ? 10 : 6)
    }
}


// MARK: - 預覽
#Preview {
    HomeView(drawerVM: DrawerManagerViewModel())
}

