import Foundation
import Combine
import SwiftUI

@MainActor
public final class AuthenticationViewModel: ObservableObject {
    // Input
    @Published public var email: String = ""
    @Published public var password: String = ""

    // Output
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil
    @Published public private(set) var isAuthenticated: Bool = false

    // Per-field validation messages
    @Published public var emailError: String? = nil
    @Published public var passwordError: String? = nil

    // Backwards-compatibility property used by some views
    @Published public var error: Error? = nil

    private var cancellables = Set<AnyCancellable>()

    /// Auth handler returns a publisher that emits `true` on success
    public typealias AuthHandler = (String, String) -> AnyPublisher<Bool, Error>

    private let authHandler: AuthHandler

    public init(authHandler: AuthHandler? = nil) {
        // Provide a default mock auth handler if none provided
        self.authHandler = authHandler ?? { email, password in
            // Simple mock: treat any non-empty credentials as success after a short delay
            Future<Bool, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    if !email.isEmpty && !password.isEmpty {
                        promise(.success(true))
                    } else {
                        promise(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
                    }
                }
            }
            .eraseToAnyPublisher()
        }

        setupValidation()
    }

    private func setupValidation() {
        // Example: clear errors when inputs change
        Publishers.CombineLatest($email, $password)
            .sink { [weak self] _, _ in
                // Reset field validation when user types
                self?.errorMessage = nil
                self?.emailError = nil
                self?.passwordError = nil
            }
            .store(in: &cancellables)
    }

    public func validate() -> Bool {
        var valid = true

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            emailError = "Email is required"
            valid = false
        } else if !trimmedEmail.contains("@") || trimmedEmail.count < 5 {
            emailError = "Enter a valid email"
            valid = false
        } else {
            emailError = nil
        }

        if password.isEmpty {
            passwordError = "Password is required"
            valid = false
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            valid = false
        } else {
            passwordError = nil
        }

        if !valid {
            errorMessage = "Please fix the errors above"
        } else {
            errorMessage = nil
        }

        return valid
    }

    public func login() {
        guard validate() else { return }

        isLoading = true
        errorMessage = nil

        authHandler(email, password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                    self.error = err
                    self.isAuthenticated = false
                }
            } receiveValue: { [weak self] success in
                guard let self = self else { return }
                self.isAuthenticated = success
                if !success {
                    self.errorMessage = "Authentication failed"
                    self.error = NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])
                }
            }
            .store(in: &cancellables)
    }

    /// Convenience login method used by some existing views
    public func login(email: String, password: String) {
        self.email = email
        self.password = password
        login()
    }

    public func logout() {
        isAuthenticated = false
        email = ""
        password = ""
    }

    /// Clear any current error state
    public func clearError() {
        errorMessage = nil
        error = nil
    }
}

// Simple preview/testing helper
extension AuthenticationViewModel {
    static var preview: AuthenticationViewModel {
        AuthenticationViewModel(authHandler: { email, password in
            Just(true)
                .setFailureType(to: Error.self)
                .delay(for: .milliseconds(500), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        })
    }
}
