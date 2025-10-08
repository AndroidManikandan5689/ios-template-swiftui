import SwiftUI

/// A reusable customizable text field supporting secure entry, icons, labels and validation state.
public struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var keyboardType: UIKeyboardType
    var sfSymbol: String?
    var onCommit: (() -> Void)?
    var validationMessage: String?

    public init(text: Binding<String>,
                placeholder: String = "",
                isSecure: Bool = false,
                keyboardType: UIKeyboardType = .default,
                sfSymbol: String? = nil,
                icon: String? = nil,
                validationMessage: String? = nil,
                onCommit: (() -> Void)? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        // icon parameter is kept for backwards compatibility with existing callers
        self.sfSymbol = sfSymbol ?? icon
        self.onCommit = onCommit
        self.validationMessage = validationMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                if let sf = sfSymbol {
                    Image(systemName: sf)
                        .foregroundColor(.secondary)
                }

                if isSecure {
                    SecureField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .keyboardType(keyboardType)
                } else {
                    TextField(placeholder, text: $text, onCommit: {
                        onCommit?()
                    })
                    .keyboardType(keyboardType)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(validationMessage == nil ? Color(.systemGray4) : Color.red, lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
            )

            if let validation = validationMessage, !validation.isEmpty {
                Text(validation)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

// Provide a preview
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextField(text: .constant(""), placeholder: "Email", sfSymbol: "envelope")
                .padding()
                .previewLayout(.sizeThatFits)

            CustomTextField(text: .constant("secret"), placeholder: "Password", isSecure: true, sfSymbol: "lock")
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
