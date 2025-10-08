import Foundation

/// Protocol to abstract UserDefaults storage for easier testing and DI
public protocol UserDefaultsServiceProtocol: AnyObject {
    // Primitive
    func set<T>(_ value: T, forKey key: String)
    func get<T>(forKey key: String) -> T?
    func remove(forKey key: String)
    
    // Codable
    func setObject<T: Codable>(_ object: T, forKey key: String)
    func getObject<T: Codable>(forKey key: String, as type: T.Type) -> T?
    
    // Bool
    func set(_ value: Bool, forKey key: String)
    func bool(forKey key: String) -> Bool
    
    // String
    func set(_ value: String, forKey key: String)
    func string(forKey key: String) -> String?
    
    // Integer
    func set(_ value: Int, forKey key: String)
    func integer(forKey key: String) -> Int
    
    // Double
    func set(_ value: Double, forKey key: String)
    func double(forKey key: String) -> Double
    
    // Array
    func set(_ value: [Any], forKey key: String)
    func array(forKey key: String) -> [Any]?
    
    // Dictionary
    func set(_ value: [String: Any], forKey key: String)
    func dictionary(forKey key: String) -> [String: Any]?
    
    // Utility
    func clearAll()
}
