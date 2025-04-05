//
//  ProfileView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel
    @State var isPreview = false
    
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
            .navigationTitle(Constants.ProfileView.profileTitle)
        }
        .environment(viewModel)
        .task {
            // Check if the user is authenticated every time the profile tab is launched or deep linked
            if !isPreview {
                await viewModel.getChef()
            }
        }
    }
}

#Preview("Logged Out") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.authState = .unauthenticated
    
    return ProfileView(viewModel: viewModel, isPreview: true)
}

#Preview("Logged In") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.authState = .authenticated
    viewModel.chef = mockRepo.mockChef
    
    return ProfileView(viewModel: viewModel, isPreview: true)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.authState = .loading
    
    return ProfileView(viewModel: viewModel, isPreview: true)
}
