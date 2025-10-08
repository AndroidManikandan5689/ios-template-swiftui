import Foundation
import OSLog

/// A logging utility for the app
final class Logger {
    // MARK: - Log Levels
    enum Level: String {
        case debug = "📘 DEBUG"
        case info = "📗 INFO"
        case warning = "📙 WARNING"
        case error = "📕 ERROR"
        case critical = "🚨 CRITICAL"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            case .critical:
                return .fault
            }
        }
    }
    
    // MARK: - Properties
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.app.logger"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    // MARK: - Logging Methods
    
    /// Log a debug message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func debug(_ message: Any,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    /// Log an info message
    static func info(_ message: Any,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    /// Log a warning message
    static func warning(_ message: Any,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    /// Log an error message
    static func error(_ message: Any,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
    
    /// Log a critical message
    static func critical(_ message: Any,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        log(message, level: .critical, file: file, function: function, line: line)
    }
    
    // MARK: - Main Logging Method
    
    /// Main logging method
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The logging level
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    static func log(_ message: Any,
                   level: Level,
                   file: String = #file,
                   function: String = #function,
                   line: Int = #line) {
        // Only log in debug mode or if explicitly enabled in environment
        #if DEBUG
        let shouldLog = true
        #else
        let shouldLog = Environment.isLoggingEnabled
        #endif
        
        guard shouldLog else { return }
        
        // Create log components
        let timestamp = dateFormatter.string(from: Date())
        let filename = (file as NSString).lastPathComponent
        
        // Format the log message
        let formattedMessage = """
        \(level.rawValue) [\(timestamp)]
        📍 \(filename):\(line) \(function)
        📝 \(message)
        ________________________________
        
        """
        
        // Print to console
        print(formattedMessage)
        
        // Log to OS system
        let logger = os.Logger(subsystem: subsystem, category: filename)
//        logger.log(level: level.osLogType, "\(message)")
        
        #if DEBUG
        // In debug mode, you might want to add additional logging
        if level == .critical || level == .error {
            // You could trigger a breakpoint here
            // raise(SIGINT)
        }
        #endif
    }
    
    // MARK: - Network Logging
    
    /// Log network requests
    static func logRequest(_ request: URLRequest) {
        let urlString = request.url?.absoluteString ?? "nil"
        let method = request.httpMethod ?? "nil"
        let headers = request.allHTTPHeaders ?? [:]
        
        var message = """
        🌐 Network Request
        URL: \(urlString)
        Method: \(method)
        Headers: \(headers)
        """
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            message += "\nBody: \(bodyString)"
        }
        
        debug(message)
    }
    
    /// Log network responses
    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        var message = "🌐 Network Response\n"
        
        if let httpResponse = response as? HTTPURLResponse {
            message += "Status Code: \(httpResponse.statusCode)\n"
        }
        
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            message += "Response: \(jsonString)\n"
        }
        
        if let error = error {
            message += "Error: \(error.localizedDescription)"
        }
        
        debug(message)
    }
}

// MARK: - URLRequest Extension
private extension URLRequest {
    var allHTTPHeaders: [String: String]? {
        allHTTPHeaderFields
    }
}

// MARK: - Usage Examples
/*
 // Basic logging
 Logger.debug("Debug message")
 Logger.info("Info message")
 Logger.warning("Warning message")
 Logger.error("Error message")
 Logger.critical("Critical message")
 
 // Network logging
 Logger.logRequest(urlRequest)
 Logger.logResponse(response, data: responseData, error: error)
 
 // Logging with context
 Logger.debug("User logged in successfully", file: #file, function: #function, line: #line)
 
 // Error logging
 do {
     try someRiskyOperation()
 } catch {
     Logger.error("Failed to perform operation: \(error)")
 }
 */
