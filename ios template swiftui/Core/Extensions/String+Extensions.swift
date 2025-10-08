import Foundation
import UIKit

extension String {
    // MARK: - Validation
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
    
    var isNumeric: Bool {
        return self.allSatisfy { $0.isNumber }
    }
    
    var isAlphanumeric: Bool {
        return self.allSatisfy { $0.isNumber || $0.isLetter }
    }
    
    // MARK: - Formatting
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func truncate(to length: Int, withEllipsis: Bool = true) -> String {
        if self.count <= length {
            return self
        }
        return withEllipsis ? String(self.prefix(length)) + "..." : String(self.prefix(length))
    }
    
    func padding(toLength length: Int, withPad pad: String = " ", startingAt start: Int = 0) -> String {
        return self.padding(toLength: length, withPad: pad, startingAt: start)
    }
    
    // MARK: - Case Conversion
    var camelCase: String {
        guard !isEmpty else { return "" }
        let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let first = parts.first?.lowercased() ?? ""
        let rest = parts.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }
    
    var snakeCase: String {
        guard !isEmpty else { return "" }
        var result = ""
        for (index, char) in self.enumerated() {
            if index != 0 && char.isUppercase {
                result += "_"
            }
            result += char.lowercased()
        }
        return result
    }
    
    var kebabCase: String {
        return self.snakeCase.replacingOccurrences(of: "_", with: "-")
    }
    
    // MARK: - Substring Operations
    func substring(from index: Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: max(0, index))
        return String(self[fromIndex...])
    }
    
    func substring(to index: Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: min(index, count))
        return String(self[..<toIndex])
    }
    
    func substring(with range: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: max(0, range.lowerBound))
        let endIndex = self.index(self.startIndex, offsetBy: min(range.upperBound, count))
        return String(self[startIndex..<endIndex])
    }
    
    // MARK: - HTML Handling
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    var htmlStripped: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    // MARK: - URL Handling
    var isValidUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
    
    var urlDecoded: String {
        return self.removingPercentEncoding ?? self
    }
    
    // MARK: - JSON Handling
    var jsonObject: Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    // MARK: - Localization
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    // MARK: - Random String Generation
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    // MARK: - Custom Mask
    func masked(with pattern: String = "XXX-XXX", char: Character = "X") -> String {
        var result = ""
        var index = self.startIndex
        
        for patternChar in pattern {
            guard index < self.endIndex else { break }
            
            if patternChar == char {
                result.append(self[index])
                index = self.index(after: index)
            } else {
                result.append(patternChar)
            }
        }
        
        return result
    }
    
    // MARK: - Subscripting
    subscript(value: Int) -> Character? {
        guard value >= 0, value < count else { return nil }
        return self[index(startIndex, offsetBy: value)]
    }
    
    subscript(value: NSRange) -> String {
        guard value.location >= 0, value.length >= 0, value.location + value.length <= count else { return "" }
        let start = index(startIndex, offsetBy: value.location)
        let end = index(start, offsetBy: value.length)
        return String(self[start..<end])
    }
}

// MARK: - Convenience Extensions for Numbers and Currency
extension String {
    func currencyFormatted(with symbol: String = "$", decimalPlaces: Int = 2) -> String? {
        guard let number = Double(self) else { return nil }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        
        return formatter.string(from: NSNumber(value: number))
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    var toFloat: Float? {
        return Float(self)
    }
}

// Example Usage:
/*
 // Validation
 let email = "user@example.com"
 if email.isEmail {
     print("Valid email")
 }
 
 // Formatting
 let longText = "This is a very long text"
 print(longText.truncate(to: 10)) // "This is a..."
 
 // Case conversion
 let text = "HelloWorld"
 print(text.snakeCase) // "hello_world"
 
 // Masking
 let phone = "1234567890"
 print(phone.masked(with: "XXX-XXX-XXXX")) // "123-456-7890"
 
 // Currency
 let amount = "1234.56"
 print(amount.currencyFormatted()) // "$1,234.56"
 
 // HTML
 let html = "<p>Hello</p>"
 print(html.htmlStripped) // "Hello"
 
 // URL
 let url = "https://example.com"
 print(url.urlEncoded)
 
 // Localization
 let greeting = "Hello %@"
 print(greeting.localized(with: "World"))
*/
