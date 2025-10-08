import Foundation
import Combine
import SwiftUI

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public private(set) var user: Profile?
    @Published public private(set) var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let userDefaults: UserDefaultsServiceProtocol?

    public init(userDefaults: UserDefaultsServiceProtocol? = nil) {
        // Use provided instance if given, otherwise attempt a safe (non-crashing) resolve
        if let userDefaults = userDefaults {
            self.userDefaults = userDefaults
        } else {
            self.userDefaults = Container.shared.resolveOptional() as UserDefaultsServiceProtocol?
        }

        loadProfile()
    }

    public func loadProfile() {
        isLoading = true
        defer { isLoading = false }

        if let ud = userDefaults, let saved: User = ud.getObject(forKey: Constants.Storage.UserDefaultsKeys.currentUser, as: User.self) {
            self.user = saved
            return
        }

        // Fallback: no saved user — create a demo placeholder
        self.user = Profile(id: "0", name: "Guest User", email: "guest@example.com", avatarURL: nil, phone: nil, isActive: false, createdAt: nil, updatedAt: nil)
    }

    public func logout() {
        // Remove saved user
        userDefaults?.remove(forKey: Constants.Storage.UserDefaultsKeys.currentUser)
    }
}
