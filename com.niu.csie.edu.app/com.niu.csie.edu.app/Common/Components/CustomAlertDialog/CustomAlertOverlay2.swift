import SwiftUI



// MARK: - 主體 View
struct CustomAlertOverlay2: View {
    let title: LocalizedStringKey
    let icon: Image?
    let message: LocalizedStringKey
    let onCancel: () -> Void
    let onConfirm: () -> Void

    @Environment(\.colorScheme) private var scheme
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        let P = DialogPalette(scheme)

        ZStack {
            // 半透明背景
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 0) {
                // ====== 標題列 ======
                HStack {
                    Text(title)
                        .font(.system(size: isPad ? 26 : 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, isPad ? 14 : 10)
                        .padding(.horizontal, isPad ? 11 : 7)
                        
                    // icon 可選，存在時顯示於右側
                    if let icon = icon {
                        icon
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: isPad ? 28 : 20, height: isPad ? 28 : 20)
                            .padding(.trailing, isPad ? 17 : 11)
                    }
                }
                .background(P.titleBG)
                .clipShape(RoundedCornerShape(radius: isPad ? 18 : 12, corners: [.topLeft, .topRight]))
                
                // ====== 白色內容區 ======
                VStack(alignment: .leading, spacing: isPad ? 24 : 14) {

                    // 讓文字永遠置中顯示
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Text_Color"))
                        .frame(maxWidth: .infinity, alignment: .center) // 水平置中
                        .padding(.horizontal, 12)

                    // ---- 按鈕列 ----
                    HStack(spacing: isPad ? 22 : 16) {
                        // 給按鈕固定最小寬度 + 彈性布局平均分配
                        Button(action: onCancel) {
                            Text("Dialog_Cancel")
                                .font(.system(size: isPad ? 23 : 14))
                                .frame(minWidth: isPad ? 120 : 90) // 固定最小寬度
                                .padding(isPad ? 17 : 11)
                        }
                        .buttonStyle(DialogButtonStyle(bg: P.buttonBlue, fg: .white))
                        .frame(maxWidth: .infinity) // 讓兩個按鈕自動平均寬
                        Button(action: onConfirm) {
                            Text("Dialog_OK")
                                .font(.system(size: isPad ? 23 : 14))
                                .frame(minWidth: isPad ? 120 : 90)
                                .padding(isPad ? 17 : 11)
                        }
                        .buttonStyle(DialogButtonStyle(bg: P.buttonBlue, fg: .white))
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, isPad ? 60 : 40)
                    .padding(.bottom, isPad ? 10 : 6)
                }
                .padding(isPad ? 32 : 20)
                .background(P.cardBG)
                .clipShape(RoundedCornerShape(radius: isPad ? 18 : 12, corners: [.bottomLeft, .bottomRight]))
            }
            .frame(maxWidth: isPad ? 700 : 640)
            .shadow(radius: isPad ? 30 : 20)
            .padding(.horizontal, isPad ? 40 : 20)
        }
    }
}


#Preview {
    CustomAlertOverlay2(title: "String",icon: nil, message: "String", onCancel: {}, onConfirm: {})
        .preferredColorScheme(.light)
}
