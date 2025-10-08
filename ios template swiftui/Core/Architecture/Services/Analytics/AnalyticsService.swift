import Foundation

// MARK: - Analytics Event Protocol
protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any]? { get }
}

// MARK: - Analytics Service Protocol
protocol AnalyticsServiceProtocol {
    func logEvent(_ event: AnalyticsEvent)
    func logEvent(_ name: String, parameters: [String: Any]?)
    func setUserProperties(_ properties: [String: Any])
    func setUserID(_ userID: String)
    func reset()
}

// MARK: - Analytics Service Implementation
final class AnalyticsService: AnalyticsServiceProtocol {
    // MARK: - Singleton
    static let shared = AnalyticsService()
    
    // MARK: - Properties
    private var isConfigured: Bool = false
    private var analyticsProviders: [AnalyticsProvider] = []
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Configuration
    func configure() {
        guard !isConfigured else { return }
        
        // Initialize analytics providers
        #if DEBUG
        analyticsProviders = [ConsoleAnalyticsProvider()]
        #else
        analyticsProviders = [
            // Add your production analytics providers here
            // Example: FirebaseAnalyticsProvider(), MixpanelProvider(), etc.
        ]
        #endif
        
        isConfigured = true
        Logger.info("Analytics Service configured with \(analyticsProviders.count) providers")
    }
    
    // MARK: - Analytics Service Protocol Implementation
    func logEvent(_ event: AnalyticsEvent) {
        logEvent(event.name, parameters: event.parameters)
    }
    
    func logEvent(_ name: String, parameters: [String: Any]?) {
        guard isConfigured else {
            Logger.warning("Analytics Service not configured")
            return
        }
        
        analyticsProviders.forEach { provider in
            provider.logEvent(name, parameters: parameters)
        }
    }
    
    func setUserProperties(_ properties: [String: Any]) {
        guard isConfigured else {
            Logger.warning("Analytics Service not configured")
            return
        }
        
        analyticsProviders.forEach { provider in
            provider.setUserProperties(properties)
        }
    }
    
    func setUserID(_ userID: String) {
        guard isConfigured else {
            Logger.warning("Analytics Service not configured")
            return
        }
        
        analyticsProviders.forEach { provider in
            provider.setUserID(userID)
        }
    }
    
    func reset() {
        guard isConfigured else {
            Logger.warning("Analytics Service not configured")
            return
        }
        
        analyticsProviders.forEach { provider in
            provider.reset()
        }
    }
}

// MARK: - Analytics Provider Protocol
protocol AnalyticsProvider {
    func logEvent(_ name: String, parameters: [String: Any]?)
    func setUserProperties(_ properties: [String: Any])
    func setUserID(_ userID: String)
    func reset()
}

// MARK: - Console Analytics Provider (Debug)
class ConsoleAnalyticsProvider: AnalyticsProvider {
    func logEvent(_ name: String, parameters: [String: Any]?) {
        let parametersString = parameters?.description ?? "none"
        Logger.debug("📊 Analytics Event: \(name), Parameters: \(parametersString)")
    }
    
    func setUserProperties(_ properties: [String: Any]) {
        Logger.debug("📊 Analytics Set User Properties: \(properties)")
    }
    
    func setUserID(_ userID: String) {
        Logger.debug("📊 Analytics Set User ID: \(userID)")
    }
    
    func reset() {
        Logger.debug("📊 Analytics Reset")
    }
}

// MARK: - Common Analytics Events
extension AnalyticsService {
    enum Events {
        // Authentication Events
        struct UserLogin: AnalyticsEvent {
            let name = Constants.Analytics.Events.userLogin
            let parameters: [String: Any]?
            
            init(userId: String, method: String) {
                parameters = [
                    Constants.Analytics.Parameters.userId: userId,
                    "login_method": method
                ]
            }
        }
        
        struct UserSignup: AnalyticsEvent {
            let name = Constants.Analytics.Events.userSignup
            let parameters: [String: Any]?
            
            init(userId: String, method: String) {
                parameters = [
                    Constants.Analytics.Parameters.userId: userId,
                    "signup_method": method
                ]
            }
        }
        
        // Screen View Events
        struct ScreenView: AnalyticsEvent {
            let name = Constants.Analytics.Events.viewScreen
            let parameters: [String: Any]?
            
            init(screenName: String) {
                parameters = [
                    Constants.Analytics.Parameters.screenName: screenName
                ]
            }
        }
        
        // Error Events
        struct ErrorOccurred: AnalyticsEvent {
            let name = Constants.Analytics.Events.errorOccurred
            let parameters: [String: Any]?
            
            init(error: Error, code: Int? = nil) {
                var params: [String: Any] = [
                    Constants.Analytics.Parameters.errorMessage: error.localizedDescription
                ]
                if let code = code {
                    params[Constants.Analytics.Parameters.errorCode] = code
                }
                parameters = params
            }
        }
    }
}

// MARK: - Usage Example
/*
 // Configure analytics in AppDelegate
 func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     AnalyticsService.shared.configure()
     return true
 }
 
 // Log events
 // Simple event
 AnalyticsService.shared.logEvent("button_tap", parameters: ["button_name": "login"])
 
 // Structured event
 let loginEvent = AnalyticsService.Events.UserLogin(userId: "123", method: "email")
 AnalyticsService.shared.logEvent(loginEvent)
 
 // Screen view
 let screenEvent = AnalyticsService.Events.ScreenView(screenName: "LoginView")
 AnalyticsService.shared.logEvent(screenEvent)
 
 // Error tracking
 let errorEvent = AnalyticsService.Events.ErrorOccurred(error: someError)
 AnalyticsService.shared.logEvent(errorEvent)
 
 // User properties
 AnalyticsService.shared.setUserProperties([
     "user_type": "premium",
     "subscription_status": "active"
 ])
 
 // Set user ID
 AnalyticsService.shared.setUserID("user123")
 
 // Reset analytics
 AnalyticsService.shared.reset()
 */
