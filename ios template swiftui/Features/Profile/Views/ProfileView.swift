import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if let user = viewModel.user {
                    if let urlString = user.avatarURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }

                    Text(user.name)
                        .font(.title)
                        .bold()

                    Text(user.email)
                        .foregroundColor(.secondary)

                    if let phone = user.phone {
                        Text(phone)
                    }

                    Spacer()

                    Button(action: {
                        viewModel.logout()
                        coordinator.signOut()
                    }) {
                        Text("Logout")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    Text("No profile available")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
