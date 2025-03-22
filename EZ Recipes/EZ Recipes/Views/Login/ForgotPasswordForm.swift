//
//  ForgotPasswordForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct ForgotPasswordForm: View {
    @State private var email = ""
    
    var body: some View {
        Text(Constants.ProfileView.forgetPasswordHeader)
        
        TextField(Constants.ProfileView.emailField, text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
        
        HStack {
            Spacer()
            ProgressView()
                .opacity(1)
            Button {
                print("Send verification email")
            } label: {
                Text(Constants.ProfileView.submitButton)
            }
        }
    }
}

#Preview {
    ForgotPasswordForm()
}
