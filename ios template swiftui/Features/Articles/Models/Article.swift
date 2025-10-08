import Foundation

public struct Article: Identifiable, Codable, Equatable {
    public let id: Int
    public let title: String
    public let content: String
    public let date: String?

    public init(id: Int, title: String, content: String, date: String?) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
