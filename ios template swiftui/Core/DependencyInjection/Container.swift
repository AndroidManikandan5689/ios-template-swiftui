import Foundation

// MARK: - Container Errors
enum ContainerError: Error {
    case componentNotFound(String)
    case circularDependency(String)
    case invalidFactory
    
    var localizedDescription: String {
        switch self {
        case .componentNotFound(let name):
            return "Component not found: \(name)"
        case .circularDependency(let name):
            return "Circular dependency detected for: \(name)"
        case .invalidFactory:
            return "Invalid factory configuration"
        }
    }
}

// MARK: - Container Protocols
protocol ContainerProtocol {
    func register<T>(_ type: T.Type, factory: @escaping (Container) -> T)
    func register<T>(_ type: T.Type, instance: T)
    func resolve<T>() -> T
}

// MARK: - Component Factory
final class ComponentFactory<T> {
    private let factory: (Container) -> T
    private var instance: T?
    private let scope: ComponentScope
    
    init(scope: ComponentScope, factory: @escaping (Container) -> T) {
        self.scope = scope
        self.factory = factory
    }
    
    func resolve(from container: Container) -> T {
        switch scope {
        case .singleton:
            if let instance = instance {
                return instance
            }
            let newInstance = factory(container)
            instance = newInstance
            return newInstance
            
        case .transient:
            return factory(container)
        }
    }
}

// MARK: - Component Scope
enum ComponentScope {
    case singleton   // Single instance shared across the app
    case transient  // New instance created each time
}

// MARK: - Container Implementation
final class Container {
    // Singleton instance
    static let shared = Container()
    
    private var factories: [String: Any] = [:]
    private var resolutionStack: Set<String> = []
    
    private init() {}
    
    // MARK: - Registration Methods
    
    /// Register a type with a factory
    func register<T>(_ type: T.Type, scope: ComponentScope = .singleton, factory: @escaping (Container) -> T) {
        let key = String(describing: type)
        factories[key] = ComponentFactory(scope: scope, factory: factory)
    }
    
    /// Register a singleton instance
    func register<T>(_ type: T.Type, instance: T) {
        register(type) { _ in instance }
    }
    
    /// Register a protocol (interface) with a concrete implementing type.
    /// The `Implementation` must conform to the `Interface` (proto) so the returned
    /// value can be safely upcast to the protocol existential.
//    func register<Interface, Implementation>(_ proto: Interface.Type, implementation: Implementation.Type, scope: ComponentScope = .singleton) where Implementation: AnyObject, Implementation: Interface {
//        register(proto, scope: scope) { container in
//            // Resolve the concrete implementation and return it as the protocol existential
//            let impl: Implementation = container.resolve()
//            return impl as Interface
//        }
//    }
    
    // MARK: - Resolution Methods
    
    /// Resolve a type. This will crash with a helpful message if the component
    /// is not registered or a circular dependency is detected. Use `resolveOptional`
    /// if you want a non-crashing lookup.
    func resolve<T>() -> T {
        let key = String(describing: T.self)

        // Check for circular dependencies
        guard !resolutionStack.contains(key) else {
            fatalError("Circular dependency detected for: \(key)")
        }

        resolutionStack.insert(key)
        defer { resolutionStack.remove(key) }

        guard let factory = factories[key] as? ComponentFactory<T> else {
            fatalError("Component not found: \(key). Make sure it was registered before resolving.")
        }

        return factory.resolve(from: self)
    }

    /// Resolve an optional type without crashing when not found
    func resolveOptional<T>() -> T? {
        let key = String(describing: T.self)
        guard let factory = factories[key] as? ComponentFactory<T> else {
            return nil
        }
        return factory.resolve(from: self)
    }
}

// MARK: - Container Extensions
extension Container {
    // MARK: - Service Registration
    
    /// Register core services
    func registerServices() {
        // Network Service
        register(NetworkServiceProtocol.self) { _ in
            NetworkService() as NetworkServiceProtocol
        }
        
        // API Service
//        register(APIServiceProtocol.self) { container in
//            let networkService: NetworkServiceProtocol = container.resolve()
//            return APIService(networkService: networkService)
//        }
//        
//        // Storage Service
//        register(StorageServiceProtocol.self) { _ in
//            StorageService()
//        }
        
        // Analytics Service
//        register(AnalyticsServiceProtocol.self) { _ in
//            AnalyticsService()
//        }
    }
    
    // MARK: - Repository Registration
    
    /// Register repositories
    func registerRepositories() {
        // User Repository
//        register(UserRepositoryProtocol.self) { container in
//            let apiService: APIServiceProtocol = container.resolve()
//            let storageService: StorageServiceProtocol = container.resolve()
//            return UserRepository(apiService: apiService, storageService: storageService)
//        }
//        
//        // Authentication Repository
//        register(AuthRepositoryProtocol.self) { container in
//            let apiService: APIServiceProtocol = container.resolve()
//            let storageService: StorageServiceProtocol = container.resolve()
//            return AuthRepository(apiService: apiService, storageService: storageService)
//        }

        // Articles Repository
        register(ArticlesRepositoryProtocol.self) { container in
            let network: NetworkServiceProtocol = container.resolve()
            return ArticlesRepository(network: network)
        }
    }
    
    // MARK: - ViewModel Registration
    
    /// Register view models
    func registerViewModels() {
        // Auth ViewModel
//        register(AuthenticationViewModel.self, scope: .transient) { container in
//            let authRepository: AuthRepositoryProtocol = container.resolve()
//            let analyticsService: AnalyticsServiceProtocol = container.resolve()
//            return AuthenticationViewModel(
//                authRepository: authRepository,
//                analyticsService: analyticsService
//            )
//        }
//        
//        // Profile ViewModel
//        register(ProfileViewModel.self, scope: .transient) { container in
//            let userRepository: UserRepositoryProtocol = container.resolve()
//            return ProfileViewModel(userRepository: userRepository)
//        }
    }
}

// MARK: - Usage Example
/*
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDependencies()
        return true
    }
    
    private func setupDependencies() {
        let container = Container.shared
        
        // Register all dependencies
        container.registerServices()
        container.registerRepositories()
        container.registerViewModels()
    }
}

// In your SwiftUI views:
struct LoginView: View {
    @StateObject private var viewModel: AuthenticationViewModel = Container.shared.resolve()
    
    var body: some View {
        // View implementation
    }
}

// In your repositories:
class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(apiService: APIServiceProtocol, storageService: StorageServiceProtocol) {
        self.apiService = apiService
        self.storageService = storageService
    }
}

// In your view models:
class ProfileViewModel: BaseViewModel {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
        super.init()
    }
}
*/
