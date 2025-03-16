//
//  ProfileView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/17/25.
//

import SwiftUI

struct ProfileView: View {
    @State var authState: AuthState = .unauthenticated
    
    var body: some View {
        NavigationStack {
            Group {
                switch authState {
                case .authenticated:
                    ProfileLoggedIn()
                case .unauthenticated:
                    ProfileLoggedOut()
                case .loading:
                    VStack {
                        ProgressView()
                        Text(Constants.ProfileView.profileLoading)
                    }
                }
            }
            .navigationTitle(Constants.ProfileView.profileTitle)
        }
    }
}

#Preview("Logged Out") {
    ProfileView(authState: .unauthenticated)
}

#Preview("Logged In") {
    ProfileView(authState: .authenticated)
}

#Preview("Loading") {
    ProfileView(authState: .loading)
}
