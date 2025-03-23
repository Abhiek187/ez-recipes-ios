//
//  ForgotPasswordForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct ForgotPasswordForm: View {
    @State private var email = ""
    @State private var isLoading = false
    @State private var emailSent = false
    
    @State private var emailEmpty = false
    @State private var emailInvalid = false
    
    var body: some View {
        VStack(spacing: 16) {
            if !emailSent {
                Text(Constants.ProfileView.forgetPasswordHeader)
                    .font(.title3)
                
                TextField(Constants.ProfileView.emailField, text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) {
                        withAnimation {
                            emailEmpty = email.isEmpty
                            emailInvalid = email.wholeMatch(of: Constants.emailRegex) == nil
                        }
                    }
                FormError(on: emailEmpty, message: Constants.ProfileView.fieldRequired("Email"))
                FormError(on: emailInvalid, message: Constants.ProfileView.emailInvalid)
                
                HStack {
                    Spacer()
                    ProgressView()
                        .opacity(isLoading ? 1 : 0)
                    Button {
                        emailSent = true
                    } label: {
                        Text(Constants.ProfileView.submitButton)
                    }
                    .font(.title3)
                    .disabled(emailEmpty || emailInvalid || isLoading)
                }
            } else {
                Text(Constants.ProfileView.forgetPasswordConfirm(email))
            }
        }
        .padding()
    }
}

#Preview {
    ForgotPasswordForm()
}
