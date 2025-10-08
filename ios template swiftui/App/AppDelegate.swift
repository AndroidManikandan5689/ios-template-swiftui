import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupServices()
        return true
    }
    
    private func setupServices() {
        // Initialize Analytics Service first
        AnalyticsService.shared.configure()
        
        // Initialize other services
        let container = Container.shared

        // Register built-in services, repositories and view models
        container.registerServices()
        container.registerRepositories()
        container.registerViewModels()

        // Manual inline registrations for concrete/shared instances (if any)
        container.register(NetworkServiceProtocol.self) { _ in NetworkService() as NetworkServiceProtocol }
        container.register(AnalyticsServiceProtocol.self) { _ in AnalyticsService.shared }
        container.register(UserDefaultsServiceProtocol.self) { _ in UserDefaultsService.shared as UserDefaultsServiceProtocol }
    }
}
