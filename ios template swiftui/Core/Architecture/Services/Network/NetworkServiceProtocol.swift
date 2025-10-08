import Foundation
import Combine

/// Protocol that defines the network service contract used across the app.
public protocol NetworkServiceProtocol {
    /// Perform a request and decode the response to a Decodable type.
    func request<T: Decodable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError>
    /// Perform a request and return raw Data.
    func request(_ request: NetworkRequest) -> AnyPublisher<Data, NetworkError>
    /// Upload raw data to a given endpoint.
    func upload(data: Data, to endpoint: String, withName name: String) -> AnyPublisher<Data, NetworkError>
    /// Download data from a URL.
    func download(from url: URL) -> AnyPublisher<Data, NetworkError>
}
