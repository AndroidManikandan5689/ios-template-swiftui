import SwiftUI
import UIKit

enum Typography {
	// MARK: - Colors used specifically for typography (bridge for UIKit appearances)
	enum Colors {
		static let title = Color("TextPrimary")
		static let body = Color("TextPrimary")
		static let muted = Color("TextSecondary")
	}

	// MARK: - Font families / helpers
	private static let primaryFontName = "Roboto-Regular" // replace with actual bundled font name if present
	private static let primaryBoldFontName = "Roboto-Bold"

	// Provide UIFont for use in UIKit appearance proxies
	enum UIFonts {
		static func title1() -> UIFont { UIFont.preferredFont(forTextStyle: .largeTitle) }
		static func title2() -> UIFont { UIFont.preferredFont(forTextStyle: .title1) }
		static func title3() -> UIFont { UIFont.preferredFont(forTextStyle: .title2) }
		static func headline() -> UIFont { UIFont.preferredFont(forTextStyle: .headline) }
		static func body() -> UIFont { UIFont.preferredFont(forTextStyle: .body) }
		static func callout() -> UIFont { UIFont.preferredFont(forTextStyle: .callout) }
		static func footnote() -> UIFont { UIFont.preferredFont(forTextStyle: .footnote) }
		static func caption() -> UIFont { UIFont.preferredFont(forTextStyle: .caption1) }
	}

	// MARK: - SwiftUI Font tokens
	enum Fonts {
		static let largeTitle: Font = .system(.largeTitle, design: .default).weight(.bold)
		static let title: Font = .system(.title, design: .default).weight(.semibold)
		static let headline: Font = .system(.headline, design: .default)
		static let body: Font = .system(.body, design: .default)
		static let callout: Font = .system(.callout, design: .default)
		static let footnote: Font = .system(.footnote, design: .default)
		static let caption: Font = .system(.caption, design: .default)
	}

	// Convenience: create custom fonts by name (fallback to system)
	static func customFont(name: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
		if UIFont.familyNames.contains(where: { $0 == name }) {
			return .custom(name, size: size)
		}
		return .system(size: size, weight: weight)
	}
}

