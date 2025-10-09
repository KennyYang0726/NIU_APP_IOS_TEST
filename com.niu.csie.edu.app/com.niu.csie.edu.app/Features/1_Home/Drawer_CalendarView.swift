import SwiftUI



struct Drawer_CalendarView: View {
    @ObservedObject var vm: DrawerManagerViewModel
    
    var body: some View {
        VStack {
            Text("Drawer_CalendarView頁面")
            Button("回首頁") {
                vm.switchPage(to: .home)
            }
        }
    }
}
