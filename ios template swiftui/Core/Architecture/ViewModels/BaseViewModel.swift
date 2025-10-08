import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    func handleError(_ error: Error) {
        self.error = error
        Logger.log(error.localizedDescription, level: .error)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
