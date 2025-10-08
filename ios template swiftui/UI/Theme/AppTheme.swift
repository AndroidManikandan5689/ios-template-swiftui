import SwiftUI
import UIKit

/// Centralized theme tokens for colors, spacing and common UI appearance helpers.
enum AppTheme {
	// MARK: - Colors
	enum Colors {
		static let primary = Color("PrimaryColor") // defined in Assets.xcassets
		static let background = Color("BackgroundColor")
		static let surface = Color("SurfaceColor")
		static let accent = Color("AccentColor")
		static let success = Color("SuccessColor")
		static let warning = Color("WarningColor")
		static let error = Color("ErrorColor")
		static let textPrimary = Color("TextPrimary")
		static let textSecondary = Color("TextSecondary")
	}

	// MARK: - Spacing
	enum Spacing {
		static let xs: CGFloat = 4
		static let sm: CGFloat = 8
		static let md: CGFloat = 16
		static let lg: CGFloat = 24
		static let xl: CGFloat = 32
	}

	// MARK: - Corner radii
	enum Radius {
		static let small: CGFloat = 6
		static let medium: CGFloat = 12
		static let large: CGFloat = 20
	}

	// MARK: - Apply global appearance (UINavigationBar, UITabBar, etc.)
	/// Call at app startup to apply UIKit appearances that match the SwiftUI theme.
	static func applyAppearance() {
		// Navigation Bar
		let navAppearance = UINavigationBarAppearance()
		navAppearance.configureWithOpaqueBackground()
		navAppearance.backgroundColor = UIColor(Color.background)
		navAppearance.titleTextAttributes = [.foregroundColor: UIColor(Typography.Colors.title)]
		navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Typography.Colors.title)]

		UINavigationBar.appearance().standardAppearance = navAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = navAppearance

		// Tab Bar
		let tabAppearance = UITabBarAppearance()
		tabAppearance.configureWithOpaqueBackground()
		tabAppearance.backgroundColor = UIColor(Color(UIColor.systemBackground))
		UITabBar.appearance().standardAppearance = tabAppearance
		if #available(iOS 15.0, *) {
			UITabBar.appearance().scrollEdgeAppearance = tabAppearance
		}

		// Table view background
		UITableView.appearance().backgroundColor = UIColor(Color.clear)

		// Global tint
		UIWindow.appearance().tintColor = UIColor(AppTheme.Colors.accent)
	}
}

