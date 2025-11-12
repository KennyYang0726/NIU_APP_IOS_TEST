import SwiftUI



@MainActor
final class EUNI1_ListViewModel: ObservableObject, Identifiable {
    @Published var isExpanded: Bool = false
    
    let name: String
    let id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    func toggleExpanded() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isExpanded.toggle()
        }
    }
}
