import SwiftUI


// 單一按鈕
struct CustomAlertOverlay1: View {
    let title: String
    let message: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Alert Dialog 本體
            VStack(spacing: 16) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? .gray : .secondary)
                    .padding(.horizontal, 12)
                
                HStack(spacing: 20) {
                    Button("取消") {
                        onCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("確定") {
                        onConfirm()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.blue.opacity(0.7) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 5)
            }
            .padding()
            .frame(maxWidth: 320)
            .background(colorScheme == .dark ? Color(hex: "#1C1C1E") : Color.white)
            .cornerRadius(18)
            .shadow(radius: 20)
            .transition(.scale)
        }
        .animation(.easeInOut(duration: 0.25), value: true)
    }
}


