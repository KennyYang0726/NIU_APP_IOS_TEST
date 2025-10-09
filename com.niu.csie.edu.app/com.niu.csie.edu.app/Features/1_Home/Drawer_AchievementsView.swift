import SwiftUI



struct Drawer_AchievementsView: View {
    @ObservedObject var vm: DrawerManagerViewModel
    
    var body: some View {
        VStack {
            Text("Drawer_AchievementsView頁面")
            Button("回首頁") {
                vm.switchPage(to: .home)
            }
        }
    }
}
