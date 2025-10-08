import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    var apiBaseURL: String {
        switch self {
        case .development:
            return "https://newsapp-spring-webservice.onrender.com"
        case .staging:
            return "https://newsapp-spring-webservice.onrender.com"
        case .production:
            return "https://newsapp-spring-webservice.onrender.com"
        }
    }
}
