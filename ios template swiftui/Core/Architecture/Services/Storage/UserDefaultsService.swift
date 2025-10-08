import Foundation

/// A service for managing app data using UserDefaults.
final class UserDefaultsService: UserDefaultsServiceProtocol {
    public static let shared = UserDefaultsService()
    private let defaults: UserDefaults

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Primitive Types
    public func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    public func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    // MARK: - Codable Support
    public func setObject<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    public func getObject<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
    
    // MARK: - Bool Convenience
    public func set(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func bool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }
    
    // MARK: - String Convenience
    public func set(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func string(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }
    
    // MARK: - Integer Convenience
    public func set(_ value: Int, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func integer(forKey key: String) -> Int {
        defaults.integer(forKey: key)
    }
    
    // MARK: - Double Convenience
    public func set(_ value: Double, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func double(forKey key: String) -> Double {
        defaults.double(forKey: key)
    }
    
    // MARK: - Array Convenience
    public func set(_ value: [Any], forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func array(forKey key: String) -> [Any]? {
        defaults.array(forKey: key)
    }
    
    // MARK: - Dictionary Convenience
    public func set(_ value: [String: Any], forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func dictionary(forKey key: String) -> [String: Any]? {
        defaults.dictionary(forKey: key)
    }
    
    // MARK: - Utility
    public func clearAll() {
        for (key, _) in defaults.dictionaryRepresentation() {
            defaults.removeObject(forKey: key)
        }
    }
}

// MARK: - Usage Example
/*
 // Store a value
 UserDefaultsService.shared.set(true, forKey: "isLoggedIn")
 
 // Retrieve a value
 let isLoggedIn = UserDefaultsService.shared.bool(forKey: "isLoggedIn")
 
 // Store a Codable object
 let user = User(id: "1", name: "John")
 UserDefaultsService.shared.setObject(user, forKey: "currentUser")
 
 // Retrieve a Codable object
 let currentUser = UserDefaultsService.shared.getObject(forKey: "currentUser", as: User.self)
 
 // Remove a value
 UserDefaultsService.shared.remove(forKey: "isLoggedIn")
 
 // Clear all
 UserDefaultsService.shared.clearAll()
*/
