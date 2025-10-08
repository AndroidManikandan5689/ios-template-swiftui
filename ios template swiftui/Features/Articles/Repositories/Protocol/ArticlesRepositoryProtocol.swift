import Foundation
import Combine

public protocol ArticlesRepositoryProtocol {
    func fetchArticles() -> AnyPublisher<[Article], Error>
}
