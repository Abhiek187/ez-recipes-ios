//
//  ProfileView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

import SwiftUI
import AlertToast

struct ProfileView: View {
    var viewModel: ProfileViewModel
    var profileAction: ProfileAction? = nil
    var isPreview = false
    
    @State private var showToast = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.authState == .authenticated, let chef = viewModel.chef {
                    ProfileLoggedIn(chef: chef)
                } else if viewModel.authState == .unauthenticated {
                    ProfileLoggedOut()
                } else {
                    VStack {
                        ProgressView()
                        Text(Constants.ProfileView.profileLoading)
                    }
                }
            }
            .navigationTitle(Constants.Tabs.profileTitle)
        }
        .environment(viewModel)
        .task {
            // Check if the user is authenticated every time the profile tab is launched or deep linked
            if !isPreview {
                await viewModel.getChef()
            }
        }
        .onChange(of: profileAction) {
            showToast = profileAction != nil
        }
        .toast(isPresenting: $showToast) {
            switch profileAction {
            case .verifyEmail:
                AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.emailVerifySuccess)
            case .changeEmail:
                AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.changeEmailSuccess, subTitle: Constants.ProfileView.signInAgain)
            case .resetPassword:
                AlertToast(displayMode: .banner(.pop), type: .regular, title: Constants.ProfileView.changePasswordSuccess, subTitle: Constants.ProfileView.signInAgain)
            case .none:
                // Shouldn't be seen normally
                AlertToast(displayMode: .banner(.pop), type: .error(.red), title: Constants.unknownError)
            }
        }
    }
}

@MainActor
private func setupPreview(authState: AuthState, profileAction: ProfileAction? = nil) -> some View {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.authState = authState
    viewModel.chef = authState == .authenticated ? mockRepo.mockChef : nil
    
    return ProfileView(viewModel: viewModel, profileAction: profileAction, isPreview: true)
}

#Preview("Logged Out") {
    setupPreview(authState: .unauthenticated)
}

#Preview("Logged In") {
    setupPreview(authState: .authenticated)
}

#Preview("Loading") {
    setupPreview(authState: .loading)
}

#Preview("Verified Email") {
    setupPreview(authState: .authenticated, profileAction: .verifyEmail)
}

#Preview("Changed Email") {
    setupPreview(authState: .unauthenticated, profileAction: .changeEmail)
}

#Preview("Reset Password") {
    setupPreview(authState: .unauthenticated, profileAction: .resetPassword)
}
