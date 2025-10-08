import Foundation

public struct User: Codable, Identifiable, Equatable {
    public let id: String
    public var name: String
    public var email: String
    public var avatarURL: String?
    public var phone: String?
    public var isActive: Bool
    public var createdAt: Date?
    public var updatedAt: Date?
    
    // Example: Custom CodingKeys if your API uses snake_case
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatarURL = "avatar_url"
        case phone
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// Example Usage:
/*
let user = User(id: "1", name: "AndroidMani", email: "mani@example.com", avatarURL: nil, phone: nil, isActive: true, createdAt: Date(), updatedAt: Date())
*/
