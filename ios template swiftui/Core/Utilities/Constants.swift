import Foundation
import SwiftUI

/// Constants used throughout the application
public enum Constants {
    // MARK: - API Constants
    public enum API {
        /// API timeout interval
        public static let timeoutInterval: TimeInterval = 30
        
        /// API error codes
        enum ErrorCode {
            static let unauthorized = 401
            static let forbidden = 403
            static let notFound = 404
            static let serverError = 500
        }
        
        /// API Headers
        enum Headers {
            static let authorization = "Authorization"
            static let contentType = "Content-Type"
            static let accept = "Accept"
            static let apiKey = "Api-Key"
            static let bearer = "Bearer"
        }
        
        /// Content Types
        enum ContentType {
            static let json = "application/json"
            static let multipart = "multipart/form-data"
            static let urlEncoded = "application/x-www-form-urlencoded"
        }
    }
    
    // MARK: - Storage Keys
    enum Storage {
        /// UserDefaults Keys
        enum UserDefaultsKeys {
            static let isLoggedIn = "isLoggedIn"
            static let authToken = "authToken"
            static let currentUser = "currentUser"
            static let lastSync = "lastSync"
            static let appTheme = "appTheme"
            static let userPreferences = "userPreferences"
        }
        
        /// Keychain Keys
        enum KeychainKeys {
            static let accessToken = "accessToken"
            static let refreshToken = "refreshToken"
            static let userCredentials = "userCredentials"
        }
    }
    
    // MARK: - UI Constants
    enum UI {
        /// General Spacing
        enum Spacing {
            static let tiny: CGFloat = 4
            static let small: CGFloat = 8
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
            static let extraLarge: CGFloat = 32
        }
        
        /// Corner Radius
        enum CornerRadius {
            static let small: CGFloat = 4
            static let medium: CGFloat = 8
            static let large: CGFloat = 12
            static let extraLarge: CGFloat = 16
            static let circular: CGFloat = 9999
        }
        
        /// Animation Duration
        enum AnimationDuration {
            static let fast: Double = 0.2
            static let medium: Double = 0.3
            static let slow: Double = 0.5
        }
        
        /// Shadow
//        enum Shadow {
//            static let light = Shadow(color: .black, radius: 4, x: 0, y: 2, opacity: 0.1)
//            static let medium = Shadow(color: .black, radius: 8, x: 0, y: 4, opacity: 0.15)
//            static let heavy = Shadow(color: .black, radius: 16, x: 0, y: 8, opacity: 0.2)
//            
//            let color: Color
//            let radius: CGFloat
//            let x: CGFloat
//            let y: CGFloat
//            let opacity: Double
//        }
        
        /// Font Sizes
        enum FontSize {
            static let caption: CGFloat = 12
            static let footnote: CGFloat = 13
            static let subheadline: CGFloat = 15
            static let body: CGFloat = 17
            static let headline: CGFloat = 17
            static let title3: CGFloat = 20
            static let title2: CGFloat = 22
            static let title1: CGFloat = 28
            static let largeTitle: CGFloat = 34
        }
    }
    
    // MARK: - Validation
    enum Validation {
        /// Regex Patterns
        enum Regex {
            static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            static let password = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
            static let phone = "^[0-9+]{0,1}+[0-9]{5,16}$"
            static let username = "^[a-zA-Z0-9_]{3,16}$"
        }
        
        /// Input Limits
        enum Limits {
            static let minPasswordLength = 8
            static let maxPasswordLength = 32
            static let maxUsernameLength = 16
            static let maxNameLength = 50
            static let maxBioLength = 160
        }
    }
    
    // MARK: - Date Formats
    enum DateFormats {
        static let iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let displayDate = "MMM d, yyyy"
        static let displayTime = "h:mm a"
        static let displayDateTime = "MMM d, yyyy h:mm a"
        static let apiDate = "yyyy-MM-dd"
    }
    
    // MARK: - Analytics
    enum Analytics {
        /// Event Names
        enum Events {
            static let userLogin = "user_login"
            static let userSignup = "user_signup"
            static let userLogout = "user_logout"
            static let viewScreen = "view_screen"
            static let buttonClick = "button_click"
            static let errorOccurred = "error_occurred"
        }
        
        /// Parameter Keys
        enum Parameters {
            static let userId = "user_id"
            static let screenName = "screen_name"
            static let buttonName = "button_name"
            static let errorMessage = "error_message"
            static let errorCode = "error_code"
        }
    }
    
    // MARK: - Notifications
    enum NotificationNames {
        static let userDidLogin = Notification.Name("userDidLogin")
        static let userDidLogout = Notification.Name("userDidLogout")
        static let themeDidChange = Notification.Name("themeDidChange")
        static let networkStatusChanged = Notification.Name("networkStatusChanged")
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let networkError = "Unable to connect to the server. Please check your internet connection."
        static let serverError = "Something went wrong on our end. Please try again later."
        static let invalidCredentials = "Invalid email or password."
        static let sessionExpired = "Your session has expired. Please log in again."
        static let invalidInput = "Please check your input and try again."
        static let unknownError = "An unexpected error occurred. Please try again."
    }
}

// MARK: - Usage Examples

 // API Constants
 let timeout = Constants.API.timeoutInterval
 let headers = [
     Constants.API.Headers.contentType: Constants.API.ContentType.json
 ]
 
 // Storage
// UserDefaultsService.shared.bool(forKey: Constants.Storage.UserDefaultsKeys.isLoggedIn)
// 
// // UI
// Text("Hello")
//     .padding(Constants.UI.Spacing.medium)
//     .cornerRadius(Constants.UI.CornerRadius.medium)
// 
// // Validation
// let isValidEmail = email.matches(Constants.Validation.Regex.email)
// 
// // Analytics
// analytics.logEvent(Constants.Analytics.Events.userLogin, parameters: [
//     Constants.Analytics.Parameters.userId: userId
// ])
// 
// // Error Handling
// throw AppError.network(Constants.ErrorMessages.networkError)

