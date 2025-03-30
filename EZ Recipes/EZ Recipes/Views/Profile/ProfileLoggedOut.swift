//
//  ProfileLoggedOut.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI

struct ProfileLoggedOut: View {
    @Environment(ProfileViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Text(Constants.ProfileView.loginMessage)
            
            Button {
                viewModel.openLoginSheet = true
            } label: {
                Text(Constants.ProfileView.login)
            }
            .sheet(isPresented: $viewModel.openLoginSheet) {
                LoginSheet()
            }
            
            Spacer()
        }
        .padding()
        .font(.title2)
        .onChange(of: [viewModel.passwordUpdated, viewModel.accountDeleted]) {
            // Show messages after actions that force the user to be signed out
            if viewModel.passwordUpdated {
                print(Constants.ProfileView.changePasswordSuccess)
                viewModel.passwordUpdated = false
            } else if viewModel.accountDeleted {
                print(Constants.ProfileView.deleteAccountSuccess)
                viewModel.accountDeleted = false
            }
        }
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    ProfileLoggedOut()
        .environment(viewModel)
}
