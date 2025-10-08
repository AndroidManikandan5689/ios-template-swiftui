import SwiftUI

public struct LoadingView: View {
    public var message: String?
    public var isVisible: Bool

    public init(message: String? = nil, isVisible: Bool = true) {
        self.message = message
        self.isVisible = isVisible
    }

    public var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    if let message {
                        Text(message)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray).opacity(0.9)))
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isVisible)
        } else {
            EmptyView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Loading...", isVisible: true)
    }
}
