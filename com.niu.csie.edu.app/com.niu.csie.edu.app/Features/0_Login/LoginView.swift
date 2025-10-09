import SwiftUI

/// 負責 UI 呈現，邏輯交由 ViewModel 控制
struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    @EnvironmentObject var appState: AppState // 注入狀態
        
    var body: some View {
        let metrics = LayoutMetrics.metrics(for: hSizeClass ?? .compact)
        
        ZStack {
            VStack(spacing: metrics.mainSpacing) {
                
                // Logo
                Image("niu_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, metrics.logoHorizontalPadding)
                
                // App 名稱
                Text(LocalizedStringKey("app_name"))
                    .font(.system(size: metrics.titleFont))
                    .scaledToFit()
                    .foregroundColor(Color("Title"))
                
                // 表單區塊
                VStack(spacing: metrics.innerSpacing) {
                    
                    // 帳號輸入
                    HStack {
                        SFIcon(name: "person.fill",
                               width: metrics.innerIconWidth,
                               height: metrics.innerIconHeight)
                        
                        TextField("",
                                  text: $vm.account,
                                  prompt: Text(LocalizedStringKey("school_num"))
                                    .foregroundColor(.gray))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .frame(height: metrics.textFieldHeight)
                            .font(.system(size: metrics.textFieldHeight - metrics.innerIconWidth))
                            .padding(.leading, metrics.innerPaddingLeft)
                            .foregroundColor(.black)
                    }
                    .modifier(InputFieldModifier(height: metrics.textFieldHeight,
                                                 sidePadding: metrics.innerSpacing))
                    
                    // 密碼輸入
                    HStack {
                        SFIcon(name: "key.fill",
                               width: metrics.innerIconWidth,
                               height: metrics.innerIconHeight)
                        
                        ZStack {
                            if vm.isPasswordVisible {
                                TextField("",
                                          text: $vm.password,
                                          prompt: Text(LocalizedStringKey("pwd"))
                                            .foregroundColor(.gray))
                            } else {
                                SecureField("",
                                            text: $vm.password,
                                            prompt: Text(LocalizedStringKey("pwd"))
                                              .foregroundColor(.gray))
                            }
                        }
                        .textContentType(.password)
                        .frame(height: metrics.textFieldHeight)
                        .font(.system(size: metrics.textFieldHeight - metrics.innerIconWidth))
                        .padding(.leading, metrics.innerPaddingLeft)
                        .foregroundColor(.black)
                        
                        // 顯示/隱藏密碼
                        SFIcon(name: vm.isPasswordVisible ? "eye.fill" : "eye.slash.fill",
                               width: metrics.innerIconWidth * 1.5,
                               height: metrics.innerIconHeight)
                            .onTapGesture { vm.togglePasswordVisible() }
                    }
                    .modifier(InputFieldModifier(height: metrics.textFieldHeight,
                                                 sidePadding: metrics.innerSpacing))
                    
                    // 登入按鈕
                    Button {
                        vm.onTapLogin()
                    } label: {
                        Text(LocalizedStringKey("btn_login"))
                            .font(.system(size: metrics.textFieldHeight - metrics.innerIconWidth))
                            .padding(11)
                            .frame(maxWidth: .infinity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 40).foregroundColor(Color("Btn_Color"))
                    )
                    .padding(.horizontal, metrics.titleFont)
                    .padding(.top, metrics.innerSpacing)
                    .foregroundColor(.white)
                }
                .padding(23)
                .background(RoundedRectangle(cornerRadius: 23).foregroundColor(Color("Linear")))
                
                // 登入流程 (WebView + Toast)
                if vm.startLoginProcess {
                    ZuvioLoginWebView(
                        account: vm.zuvioLoginEmail,
                        password: vm.password
                    ) { success in
                        vm.handleLoginResult(success)
                    }
                    .frame(width: 300, height: 300)
                    .offset(x: UIScreen.main.bounds.width * 2)
                    //.frame(height: 300)
                }
            }
            .padding(metrics.mainPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color("BG_Color"))
            
            // 登入中 prog (注意！放在這裡才是全版面)
            ProgressOverlay(isVisible: $vm.showOverlay, text: vm.overlayText)
        }
        
        .onAppear {
            // 自動登入邏輯觸發
            vm.autoLogin()
        }
        
        // === Alert 與 Toast 移到這裡 ===
        .alert(item: $vm.LoginActiveAlert) { which in
            switch which {
            case .emptyFields:
                return Alert(title: Text(LocalizedStringKey("Dialog_Error_Title")),
                             message: Text(LocalizedStringKey("Dialog_Error_EmptyField")),
                             dismissButton: .default(Text(LocalizedStringKey("Dialog_OK"))))
            case .loginFailed:
                return Alert(title: Text(LocalizedStringKey("login_failed_title")),
                             message: Text(LocalizedStringKey("login_failed_message")),
                             dismissButton: .default(Text(LocalizedStringKey("Dialog_OK"))))
            }
        }
        .toast(isPresented: $vm.showSuccessToast) {
            Text(LocalizedStringKey("login_success"))
                .padding()
                .background(Color("Linear"))
                .foregroundColor(Color("Text_Color"))
                .cornerRadius(13)
            
        }
        // 控制畫面跳轉狀態
        .onChange(of: vm.zuvioLoginSuccess) { newValue in
            if newValue {
                appState.navigate(to: .home, withToast: LocalizedStringKey("login_success"))
            }
        }
    }
}

// MARK: - 共用子元件
private struct SFIcon: View {
    let name: String
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray)
            .frame(width: width, height: height)
    }
}

private struct InputFieldModifier: ViewModifier {
    let height: CGFloat
    let sidePadding: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(height: height)
            .padding(.leading, sidePadding)
            .padding(.trailing, sidePadding)
            .background(Color("Input_Field"))
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

// MARK: - 版面參數
private struct LayoutMetrics {
    let mainSpacing: CGFloat
    let mainPadding: EdgeInsets
    let logoHorizontalPadding: CGFloat
    let titleFont: CGFloat
    let innerSpacing: CGFloat
    let innerIconWidth: CGFloat
    let innerIconHeight: CGFloat
    let innerPaddingLeft: CGFloat
    let textFieldHeight: CGFloat
    
    static func metrics(for sizeClass: UserInterfaceSizeClass) -> LayoutMetrics {
        let screenHeight = UIScreen.main.bounds.height
        switch sizeClass {
        case .compact: // iPhone
            return .init(
                mainSpacing: 19,
                mainPadding: EdgeInsets(
                    top: screenHeight * 0.07,
                    leading: 19,
                    bottom: 0,
                    trailing: 19),
                logoHorizontalPadding: 111,
                titleFont: 37,
                innerSpacing: 11,
                innerIconWidth: 19,
                innerIconHeight: 23,
                innerPaddingLeft: 7,
                textFieldHeight: 37
            )
        default:       // iPad
            return .init(
                mainSpacing: 37,
                mainPadding: EdgeInsets(
                    top: screenHeight * 0.05,
                    leading: 127,
                    bottom: 0,
                    trailing: 127),
                logoHorizontalPadding: 167,
                titleFont: 71,
                innerSpacing: 23,
                innerIconWidth: 29,
                innerIconHeight: 47,
                innerPaddingLeft: 11,
                textFieldHeight: 73
            )
        }
    }
}

#Preview {
    LoginView()
}
