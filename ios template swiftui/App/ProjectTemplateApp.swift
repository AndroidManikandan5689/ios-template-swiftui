import SwiftUI

@main
struct ProjectTemplateApp: App {
    // Ensure AppDelegate lifecycle methods (and service registrations) run
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var appCoordinator = AppCoordinator()
    
    init() {
        AppTheme.applyAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(appCoordinator)
        }
    }
}
