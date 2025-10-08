import Foundation
import Combine

protocol RepositoryProtocol {
    associatedtype T
    
    func fetch() -> AnyPublisher<T, Error>
    func create(_ item: T) -> AnyPublisher<T, Error>
    func update(_ item: T) -> AnyPublisher<T, Error>
    func delete(_ id: String) -> AnyPublisher<Void, Error>
}
