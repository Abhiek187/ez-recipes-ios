//
//  VerifyEmail.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct VerifyEmail: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @State var email: String
    
    // Throttle the number of times the user can resend the verification email to satisfy API limits
    @State private var enableResend = false
    @State private var secondsRemaining = Constants.emailCooldownSeconds
    
    var body: some View {
        VStack(spacing: 16) {
            Text(Constants.ProfileView.emailVerifyHeader)
                .font(.title)
            Text(Constants.ProfileView.emailVerifyBody(email))
            
            HStack {
                Text(Constants.ProfileView.emailVerifyRetryText)
                Button {
                    Task {
                        await viewModel.sendVerificationEmail()
                        enableResend = false
                    }
                } label: {
                    Text(Constants.ProfileView.emailVerifyRetryLink)
                }
                .disabled(!enableResend)
                
                Image(systemName: "clock")
                Text(String(format: "%02d:%02d", secondsRemaining / 60, secondsRemaining % 60))
            }
            
            HStack {
                Spacer()
                Button {
                    Task {
                        await viewModel.logout()
                    }
                } label: {
                    Text(Constants.ProfileView.logout)
                }
                .font(.title3)
            }
        }
        .padding()
        .task(id: enableResend) {
            if (!enableResend) {
                secondsRemaining = Constants.emailCooldownSeconds
                
                while secondsRemaining > 0 {
                    try? await Task.sleep(for: .seconds(1))
                    secondsRemaining -= 1
                }
                enableResend = true
            }
        }
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    VerifyEmail(email: Constants.Mocks.chef.email)
        .environment(viewModel)
}
