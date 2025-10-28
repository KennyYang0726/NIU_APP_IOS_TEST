import SwiftUI



struct EventData: Identifiable, Codable {
    var id: String { eventSerialID }
    let name: String
    let department: String
    let event_state: String
    let eventSerialID: String
    let eventTime: String
    let eventLocation: String
    let eventRegisterTime: String
    let eventDetail: String
    let contactInfoName: String
    let contactInfoTel: String
    let contactInfoMail: String
    let Related_links: String
    let Multi_factor_authentication: String
    let eventPeople: String
    let Remark: String
}


struct EventRegistration_Tab1_ListView: View {
    
    @ObservedObject var vm: EventRegistration_Tab1_ListViewModel
    // 註冊 callback
    var onDetailTapped: ((EventData) -> Void)? = nil
    var onRegisterTapped: ((String) -> Void)? = nil
    
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad

    
    var body: some View {
        VStack(alignment: .leading, spacing: isPad ? 19 : 10) {
            // 上層標題列
            HStack {
                Text(vm.event.name)
                    .font(.system(size: isPad ? 41 : 20, weight: .bold))
                    .foregroundColor(Color("Text_Color"))
                Spacer()
                Text(vm.event.department)
                    .font(.system(size: isPad ? 37 : 17))
                    .foregroundColor(Color.gray)
            }
            .padding(.horizontal, 11)
            // 主要內容容器
            VStack(alignment: .leading, spacing: 8) {
                // Header: 標題與狀態（可點擊切換展開）
                HStack {
                    Text("Event_Detail_Title")
                        .font(.system(size: isPad ? 33 : 19, weight: .bold))
                        .foregroundColor(Color(hex: "#297FCA"))
                    Spacer()
                    Text(vm.localizedStateText)
                        .font(.system(size: isPad ? 29 : 17))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 9).stroke(vm.stateColor, lineWidth: 1))
                        .foregroundColor(vm.stateColor)
                    // 箭頭符號
                    Text(vm.isExpanded ? " ˇ " : " ˆ ")
                        .font(.system(size: isPad ? 37 : 29))
                        .foregroundColor(Color(hex: "#297FCA"))
                        .baselineOffset(-13)
                }
                .padding(.horizontal, 11)
                .padding(.vertical, isPad ? 15 : 1)
                .contentShape(Rectangle()) // 讓整個 HStack 可被點擊
                .onTapGesture { vm.toggleExpanded() }
                // 詳細欄位（展開時顯示）
                if vm.isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        EventInfoRow(isPad: isPad, icon: "info.circle.fill", label: "Event_ID", value: vm.event.eventSerialID)
                        EventInfoRow(isPad: isPad, icon: "calendar", label: "Event_Time", value: vm.event.eventTime)
                        EventInfoRow(isPad: isPad, icon: "mappin.and.ellipse", label: "Event_Location", value: vm.event.eventLocation)
                        EventInfoRow(isPad: isPad, icon: "clock", label: "Event_RegisterTime", value: vm.event.eventRegisterTime)
                        EventInfoRow(isPad: isPad, icon: "checkmark.seal.fill", label: "Event_Type", value: vm.event.Multi_factor_authentication)
                        EventInfoRow(isPad: isPad, icon: "person.2.fill", label: "Event_People", value: vm.event.eventPeople)
                        // 底部按鈕列
                        HStack(spacing: isPad ? 83 : 24) {
                            Button {
                                onDetailTapped?(vm.event) // 呼叫父層 callback
                            } label: {
                                Text("Event_BTN_Detail")
                                    .frame(width: isPad ? 159 : 90, height: isPad ? 53 : 37)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "#292929"))
                                    .cornerRadius(31)
                            }

                            if vm.event.event_state == "報名中" {
                                Button {
                                    onRegisterTapped?(vm.event.name) // 呼叫父層 callback
                                } label: {
                                    Text("Event_BTN_Register")
                                        .frame(width: isPad ? 159 : 90, height: isPad ? 53 : 37)
                                        .foregroundColor(.white)
                                        .background(Color(hex: "#297FCA"))
                                        .cornerRadius(31)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(Color("Linear_Inside"))
            .cornerRadius(11)
            .shadow(radius: 2)
            .padding(.horizontal, 11)
        }
        .padding(.vertical, 5)
        .background(Color("Linear"))
        Divider().background(Color(hex: "#D1D1D6")).padding(.vertical, 7)
    }
}

// MARK: - 共用資訊列
struct EventInfoRow: View {
    let isPad: Bool
    let icon: String
    let label: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .font(.system(size: isPad ? 37 : 18))
                .frame(width: isPad ? 50 : 20)
                .padding(.leading, 10)
            Text(label)
                .font(.system(size: isPad ? 31 : 14))
                .frame(width: 120, alignment: .leading)
            Spacer(minLength: isPad ? 59 : 0)
            Text(value)
                .font(.system(size: isPad ? 30 : 13))
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


// MARK: - HEX 色碼轉換
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}
