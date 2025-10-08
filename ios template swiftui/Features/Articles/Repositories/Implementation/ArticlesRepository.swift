import Foundation
import Combine

final class ArticlesRepository: ArticlesRepositoryProtocol {
    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func fetchArticles() -> AnyPublisher<[Article], Error> {
        let endpoint = "\(Environment.current.apiBaseURL)/api/articles"

        let request = NetworkRequest(endpoint: endpoint, method: .get)

        return network.request(request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
