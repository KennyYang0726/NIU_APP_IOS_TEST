import SwiftUI



struct Drawer_SettingsView: View {

    @EnvironmentObject var settings: AppSettings
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        // 自訂「主題選擇區塊」
        VStack {
            Form {
                if (isPad) {
                    HStack {
                        Text(LocalizedStringKey("Theme"))
                            .font(.system(size: 31))
                        Spacer()
                        Picker(
                            (LocalizedStringKey("Theme")), selection: $settings.theme) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                Text(LocalizedStringKey(theme.rawValue))
                            }
                        }
                        .pickerStyle(.segmented) // 類似 Android Spinner
                        .fontWidth(.expanded)
                    }
                    
                } else {
                    Picker(
                        (LocalizedStringKey("Theme")), selection: $settings.theme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(LocalizedStringKey(theme.rawValue))
                        }
                    }
                    .pickerStyle(.menu) // 類似 Android Spinner
                    .fontWidth(.expanded)
                }
            }
            .scrollContentBackground(.hidden)   // 讓 Form 不再有預設底色
            .background(.clear)                 // 可選：確保透明
            .scrollDisabled(true)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, isPad ? 37 : 19)
        
            Button {
                
            } label: {
                Text(LocalizedStringKey("delete_user_data"))
                    .font(.system(size: isPad ? 37 : 19))
                    .padding(5)
                    .frame(maxWidth: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 40).foregroundColor(Color.red)
            )
            .padding(.horizontal, isPad ? 211 : 97)
            .foregroundColor(.white)
            .padding(.vertical, isPad ? -899 : -499)
        }
        .background(Color("Linear").ignoresSafeArea()) // 全域底色
    }
}


#Preview {
    Drawer_SettingsView()
        .environmentObject(AppSettings())
}
