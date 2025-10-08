import SwiftUI

extension Color {
    // MARK: - Custom App Colors
    static let primaryBackground = Color("PrimaryBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    static let accent = Color("AccentColor")
    
    // MARK: - Semantic Colors
    static let successColor = Color("Success", bundle: nil)
    static let warningColor = Color("Warning", bundle: nil)
    static let errorColor = Color("Error", bundle: nil)
    static let info = Color("Info", bundle: nil)
    
    // MARK: - Initialization from Hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: - Color Modification
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func adjust(by percentage: CGFloat) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return self
        }
        
        let adjustedRed = min(max(red + percentage/100, 0.0), 1.0)
        let adjustedGreen = min(max(green + percentage/100, 0.0), 1.0)
        let adjustedBlue = min(max(blue + percentage/100, 0.0), 1.0)
        
        return Color(red: Double(adjustedRed),
                    green: Double(adjustedGreen),
                    blue: Double(adjustedBlue),
                    opacity: Double(alpha))
    }
    
    // MARK: - Color Properties
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return (0, 0, 0, 0)
        }
        
        return (red, green, blue, alpha)
    }
    
    var hexString: String {
        let components = self.components
        return String(
            format: "#%02X%02X%02X",
            Int(components.red * 255),
            Int(components.green * 255),
            Int(components.blue * 255)
        )
    }
    
    var isDark: Bool {
        let components = self.components
        let brightness = ((components.red * 299) +
                        (components.green * 587) +
                        (components.blue * 114)) / 1000
        return brightness < 0.5
    }
    
    // MARK: - Gradient Helpers
    func gradient(with color: Color) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [self, color]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    func angularGradient() -> AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [self, self.lighter(), self]),
            center: .center
        )
    }
    
    // MARK: - Random Color Generation
    static func random(withRandomOpacity: Bool = false) -> Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1),
            opacity: withRandomOpacity ? Double.random(in: 0...1) : 1
        )
    }
}

// MARK: - Color Scheme Helpers
extension View {
    func adaptiveColor(_ lightColor: Color, _ darkColor: Color) -> some View {
        self.environment(\.colorScheme, .light)
            .preferredColorScheme(.light)
            .foregroundColor(lightColor)
            .environment(\.colorScheme, .dark)
            .preferredColorScheme(.dark)
            .foregroundColor(darkColor)
    }
}

// Example Usage:
/*
 Text("Hello, World!")
     .foregroundColor(Color(hex: "#FF0000"))
     .background(Color.primary.lighter())
     .overlay(Color.random().opacity(0.5))
 
 Rectangle()
     .fill(Color.blue.gradient(with: .red))
 
 Circle()
     .fill(Color.primary.angularGradient())
 
 Text("Adaptive Text")
     .adaptiveColor(.black, .white)
*/
