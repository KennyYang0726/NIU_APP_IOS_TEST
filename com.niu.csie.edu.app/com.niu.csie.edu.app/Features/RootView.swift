// RootView.swift
import SwiftUI


struct RootView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.route {
            case .login:
                LoginView()
                    .environmentObject(appState)
            case .home:
                DrawerManagerView()
                    .environmentObject(appState)
            // 主畫面功能
            case .EUNI:
                EUNIView()
                    .environmentObject(appState)
            case .Score_Inquiry:
                ScoreInquiryView()
                    .environmentObject(appState)
            case .Class_Schedule:
                ClassScheduleView()
                    .environmentObject(appState)
            case .Event_Registration:
                EventRegistrationView()
                    .environmentObject(appState)
            case .Contact_Us:
                ContactUsView()
                    .environmentObject(appState)
            case .Graduation_Threshold:
                GraduationThresholdView()
                    .environmentObject(appState)
            case .Subject_System:
                SubjectSystemView()
                    .environmentObject(appState)
            case .Bus:
                BusView()
                    .environmentObject(appState)
            case .ZUVIO:
                ZuvioView()
                    .environmentObject(appState)
            case .Take_Leave:
                TakeLeaveView()
                    .environmentObject(appState)
            case .Mail:
                MailView()
                    .environmentObject(appState)
            }
        }
        .toast(isPresented: Binding(
            get: { appState.toastMessage != nil },
            set: { if !$0 { appState.toastMessage = nil } }
        )) {
            if let message = appState.toastMessage {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
            }
        }
    }
}
