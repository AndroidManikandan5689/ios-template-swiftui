// Write Homeview code here we should show welcome greeeting with user name with viewmodel
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome, \(viewModel.userName)!")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchUserName()
        }
    }
}
