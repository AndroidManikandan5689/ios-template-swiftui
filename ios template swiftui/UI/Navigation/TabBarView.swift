import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        if coordinator.isAuthenticated {
            TabView {
               HomeView()
                   .tabItem {
                       Label("Home", systemImage: "house")
                   }
               
                // Articles tab
                ArticlesView(viewModel: ArticlesViewModel(repository: Container.shared.resolve()))
                    .tabItem {
                        Label("Articles", systemImage: "doc.plaintext")
                    }

               ProfileView()
                   .tabItem {
                       Label("Profile", systemImage: "person")
                   }
            }
        } else {
            LoginView()
        }
    }
}
