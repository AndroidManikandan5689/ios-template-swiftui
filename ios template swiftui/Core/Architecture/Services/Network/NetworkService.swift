import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // Decode and return model
    func request<T: Decodable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError> {
        guard let urlRequest = buildURLRequest(from: request) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { NetworkError.unknown($0) }
            .flatMap { data -> AnyPublisher<T, NetworkError> in
                Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { _ in NetworkError.decodingError }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Return raw Data
    func request(_ request: NetworkRequest) -> AnyPublisher<Data, NetworkError> {
        guard let urlRequest = buildURLRequest(from: request) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { NetworkError.unknown($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Upload data
    func upload(data: Data, to endpoint: String, withName name: String) -> AnyPublisher<Data, NetworkError> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = data
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { NetworkError.unknown($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Download data
    func download(from url: URL) -> AnyPublisher<Data, NetworkError> {
        return session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { NetworkError.unknown($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers
    private func buildURLRequest(from request: NetworkRequest) -> URLRequest? {
        guard let url = URL(string: request.endpoint) else { return nil }

        var urlRequest = URLRequest(url: url, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.method.rawValue
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = request.body {
            urlRequest.httpBody = body
        }
        // Append query items if present
        if let queryItems = request.queryItems, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            if let newURL = components.url {
                urlRequest.url = newURL
            }
        }

        return urlRequest
    }
}
