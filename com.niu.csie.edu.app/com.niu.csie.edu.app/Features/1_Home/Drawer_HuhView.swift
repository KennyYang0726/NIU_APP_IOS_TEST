import SwiftUI



struct Drawer_HuhView: View {
    @ObservedObject var vm: DrawerManagerViewModel
    
    var body: some View {
        VStack {
            Text("Drawer_HuhView頁面")
            Button("回首頁") {
                vm.switchPage(to: .home)
            }
        }
    }
}
