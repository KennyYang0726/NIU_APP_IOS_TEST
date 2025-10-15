import SwiftUI



struct Drawer_LogoutView: View {
    @ObservedObject var vm: DrawerManagerViewModel
    
    var body: some View {
        VStack {
            Text("Drawer_LogoutView頁面")
            Button("回首頁") {
                vm.switchPage(to: .home)
            }
        }
    }
}
