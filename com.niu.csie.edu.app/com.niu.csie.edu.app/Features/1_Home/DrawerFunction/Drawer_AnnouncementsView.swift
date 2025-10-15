import SwiftUI



struct Drawer_AnnouncementsView: View {
    @ObservedObject var vm: DrawerManagerViewModel
    
    var body: some View {
        VStack {
            Text("Drawer_AnnouncementsView頁面")
            Button("回首頁") {
                vm.switchPage(to: .home)
            }
        }
    }
}
