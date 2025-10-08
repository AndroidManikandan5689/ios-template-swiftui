//write viewmodel code here for home view
import Foundation

class HomeViewModel: ObservableObject {
    @Published var userName: String = "Guest"
    
    func fetchUserName() {
        // Simulate fetching user name from a service or database
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.userName = "AndroidMani" // Replace with actual fetched name
        }
    }
}