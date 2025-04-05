//
//  ProfileLoggedOut.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI
import AlertToast

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
        // Show messages after actions that force the user to be signed out
        .toast(isPresenting: $viewModel.passwordUpdated) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.changePasswordSuccessHeader, subTitle: Constants.ProfileView.changePasswordSuccessSubHeader)
        }
        .toast(isPresenting: $viewModel.accountDeleted) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.deleteAccountSuccess)
        }
    }
}

#Preview("Regular") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    ProfileLoggedOut()
        .environment(viewModel)
}

#Preview("Password Updated") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.passwordUpdated = true
    
    return ProfileLoggedOut()
        .environment(viewModel)
}

#Preview("Account Deleted") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.accountDeleted = true
    
    return ProfileLoggedOut()
        .environment(viewModel)
}
