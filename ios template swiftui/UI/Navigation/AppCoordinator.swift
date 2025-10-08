import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func signIn() {
        isAuthenticated = true
    }
    
    func signOut() {
        isAuthenticated = false
    }
}

enum NavigationRoute: Hashable {
    case home
    case profile
    case settings
}
