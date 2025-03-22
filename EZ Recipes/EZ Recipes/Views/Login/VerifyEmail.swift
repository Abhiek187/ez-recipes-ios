//
//  VerifyEmail.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct VerifyEmail: View {
    @State var email: String
    @State private var secondsRemaining = Constants.emailCooldownSeconds
    
    var body: some View {
        Text(Constants.ProfileView.emailVerifyHeader)
            .font(.headline)
        Text(Constants.ProfileView.emailVerifyBody(email))
        
        HStack {
            Text(Constants.ProfileView.emailVerifyRetryText)
            Button {
                print("Resend verification email")
            } label: {
                Text(Constants.ProfileView.emailVerifyRetryLink)
            }
            Image(systemName: "clock")
            Text(String(format: "%02d:%02d", secondsRemaining / 60, secondsRemaining % 60))
        }
    }
}

#Preview {
    VerifyEmail(email: Constants.Mocks.chef.email)
}
