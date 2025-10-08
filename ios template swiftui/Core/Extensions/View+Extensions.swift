import SwiftUI

// MARK: - View Extensions
extension View {
    // MARK: - Conditional Modifiers
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - Loading State
    func loading(_ isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
            }
        )
        .allowsHitTesting(!isLoading)
    }
    
    // MARK: - Hide/Show
    func isHidden(_ hidden: Bool) -> some View {
        opacity(hidden ? 0 : 1)
    }
    
    // MARK: - Corner Radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    // MARK: - Border
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: width)
        )
    }
    
    // MARK: - Shadow
    func customShadow(
        color: Color = .black,
        radius: CGFloat = 10,
        x: CGFloat = 0,
        y: CGFloat = 4,
        opacity: Double = 0.1
    ) -> some View {
        self.shadow(
            color: color.opacity(opacity),
            radius: radius,
            x: x,
            y: y
        )
    }
    
    // MARK: - Placeholder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    // MARK: - Keyboard Handling
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil, from: nil, for: nil)
    }
    
    func hideKeyboardWhenTappedAround() -> some View {
        self.onTapGesture {
            dismissKeyboard()
        }
    }
    
    // MARK: - Navigation Bar Styling
    func navigationBarStyle(backgroundColor: Color, titleColor: Color) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
    
    // MARK: - Error Handling
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedError = error.wrappedValue as? LocalizedError
        return alert(
            "Error",
            isPresented: .constant(error.wrappedValue != nil),
            presenting: localizedError
        ) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.errorDescription ?? "")
        }
    }
    
    // MARK: - Size
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    // MARK: - Device Rotation
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
    
    // MARK: - Animations
    func animate(using animation: Animation = .easeInOut(duration: 0.3), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
    
    // MARK: - Debugging
    func debug(_ identifier: String) -> some View {
        print("\\(identifier): \\(type(of: self))")
        return self
    }
}

// MARK: - Supporting Types
private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct NavigationBarModifier: ViewModifier {
    var backgroundColor: Color
    var titleColor: Color
    
    init(backgroundColor: Color, titleColor: Color) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(backgroundColor)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(titleColor)]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(titleColor)]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

private struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// Example Usage:
/*
 struct ContentView: View {
     @State private var isLoading = false
     @State private var error: Error?
     @State private var text = ""
     
     var body: some View {
         VStack {
             // Conditional modifier
             Text("Hello")
                 .if(someCondition) { view in
                     view.foregroundColor(.red)
                 }
             
             // Loading state
             ContentView()
                 .loading(isLoading)
             
             // Custom corner radius
             Rectangle()
                 .cornerRadius(20, corners: [.topLeft, .topRight])
             
             // Custom border
             TextField("Enter text", text: $text)
                 .border(.blue, width: 1, cornerRadius: 8)
             
             // Custom shadow
             Card()
                 .customShadow()
             
             // Placeholder
             TextField("", text: $text)
                 .placeholder(when: text.isEmpty) {
                     Text("Enter your name").foregroundColor(.gray)
                 }
         }
         .hideKeyboardWhenTappedAround()
         .navigationBarStyle(backgroundColor: .blue, titleColor: .white)
         .errorAlert(error: $error)
         .onRotate { orientation in
             print("Device rotated to: \\(orientation)")
         }
     }
 }
 */
