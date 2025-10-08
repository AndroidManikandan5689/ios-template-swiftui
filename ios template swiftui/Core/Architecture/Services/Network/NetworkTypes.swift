import Foundation

/// Errors used by the networking layer
public enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case serverError(code: Int, message: String)
    case unauthorized
    case noInternet
    case timeout
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Error decoding data"
        case .serverError(_, let message):
            return message
        case .unauthorized:
            return "Unauthorized access"
        case .noInternet:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// Manual Equatable conformance because `Error` itself is not Equatable.
public func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidURL, .invalidURL): return true
    case (.invalidResponse, .invalidResponse): return true
    case (.noData, .noData): return true
    case (.decodingError, .decodingError): return true
    case (.unauthorized, .unauthorized): return true
    case (.noInternet, .noInternet): return true
    case (.timeout, .timeout): return true
    case (.serverError(let c1, let m1), .serverError(let c2, let m2)):
        return c1 == c2 && m1 == m2
    case (.unknown(let e1), .unknown(let e2)):
        // best-effort comparison for underlying errors
        return String(describing: e1) == String(describing: e2)
    default:
        return false
    }
}

/// Represents a network request used by the `NetworkService`.
public struct NetworkRequest {
    public let endpoint: String
    public let method: HTTPMethod
    public var headers: [String: String]?
    public var queryItems: [String: String]?
    public var body: Data?
    public var timeoutInterval: TimeInterval
    
    public init(endpoint: String,
                method: HTTPMethod = .get,
                headers: [String: String]? = nil,
                queryItems: [String: String]? = nil,
                body: Encodable? = nil,
                timeoutInterval: TimeInterval = Constants.API.timeoutInterval) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.timeoutInterval = timeoutInterval
        self.body = nil
        
        if let body = body {
            self.body = try? JSONEncoder().encode(body)
        }
    }
}
