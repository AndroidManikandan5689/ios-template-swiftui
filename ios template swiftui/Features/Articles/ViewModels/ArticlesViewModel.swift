import Foundation
import Combine

@MainActor
final class ArticlesViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let repository: ArticlesRepositoryProtocol

    init(repository: ArticlesRepositoryProtocol) {
        self.repository = repository
    }

    func load() {
        isLoading = true
        errorMessage = nil

        repository.fetchArticles()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
            }
            .store(in: &cancellables)
    }
}
