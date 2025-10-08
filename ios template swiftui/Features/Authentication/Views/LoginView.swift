import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @EnvironmentObject private var appCoordinator: AppCoordinator
    
    var body: some View {
        //Add Zstack
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                //Add Image
                Image(systemName: "lock.shield")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                //Add VStack
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                    
                                        CustomTextField(text: $viewModel.email,
                                                        placeholder: "Email",
                                                        icon: "envelope",
                                                        validationMessage: viewModel.emailError)

                                        CustomTextField(text: $viewModel.password,
                                                        placeholder: "Password",
                                                        isSecure: true,
                                                        icon: "lock",
                                                        validationMessage: viewModel.passwordError)

                                        PrimaryButton(title: "Login") {
                                                viewModel.login()
                                        }
                    .disabled(viewModel.isLoading)
                    
                }
                .padding()
                .alert("Error", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { newValue in
                    if !newValue {
                        viewModel.clearError()
                    }
                })) {
                    Button("OK") {
                        viewModel.clearError()
                    }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
                Spacer()
            }
            
            VStack{
                if viewModel.isLoading {
                    LoadingView()
                }
            }
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                appCoordinator.signIn()
            }
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

