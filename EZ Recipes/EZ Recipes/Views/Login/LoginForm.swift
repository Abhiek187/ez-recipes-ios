//
//  LoginForm.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

struct LoginForm: View {
    private enum Field: CaseIterable {
        case username
        case password
    }
    
    // For step-up authentication, only the login screen is needed
    @Environment(LoginRouter.self) private var router: LoginRouter?
    @Environment(ProfileViewModel.self) private var viewModel
    @FocusState private var focusedField: Field?
    
    @State private var username = ""
    @State private var password = ""
    
    // Focus
    @State private var usernameTouched = false
    @State private var passwordTouched = false
    
    // Errors
    @State private var usernameEmpty = true
    @State private var passwordEmpty = true
    
    let oAuthColumns = [
        GridItem(.adaptive(minimum: 140), alignment: .top)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            if let router {
                HStack {
                    Text(Constants.ProfileView.signInSubHeader)
                    Button {
                        router.navigate(to: .signUp)
                    } label: {
                        Text(Constants.ProfileView.signUpHeader)
                    }
                }
                .font(.title2)
            } else {
                Text(Constants.ProfileView.changeEmailLoginAgain)
                    .font(.title2)
            }
            
            TextField(Constants.ProfileView.usernameField, text: $username)
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .username)
                .onChange(of: username) {
                    withAnimation {
                        usernameEmpty = username.isEmpty
                    }
                }
            FormError(on: usernameTouched && usernameEmpty, message: Constants.ProfileView.fieldRequired("Username"))
            
            SecureTextField(label: Constants.ProfileView.passwordField, text: $password)
                .focused($focusedField, equals: .password)
                .onChange(of: password) {
                    withAnimation {
                        passwordEmpty = password.isEmpty
                    }
                }
            FormError(on: passwordTouched && passwordEmpty, message: Constants.ProfileView.fieldRequired("Password"))
            
            if let router {
                Button {
                    router.navigate(to: .forgotPassword)
                } label: {
                    Text(Constants.ProfileView.passwordForget)
                }
                .font(.title3)
            }
            
            Text(Constants.ProfileView.oAuthHeader)
                .font(.title3)
            LazyVGrid(columns: oAuthColumns, spacing: 16) {
                ForEach(Provider.allCases, id: \.rawValue) { provider in
                    // Handle double optional: if the provider doesn't exist in the dictionary, or if the URL is missing/invalid
                    OAuthButton(provider: provider, authUrl: viewModel.authUrls[provider]?.flatMap { $0 })
                }
            }
            
            HStack {
                Spacer()
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
                Button {
                    Task {
                        await viewModel.login(username: username, password: password)
                    }
                } label: {
                    Text(Constants.ProfileView.login)
                }
                .font(.title3)
                .disabled(usernameEmpty || passwordEmpty || viewModel.isLoading)
            }
        }
        .padding()
        .keyboardNavigation(focusedField: $focusedField)
        .onChange(of: focusedField) {
            withAnimation {
                if focusedField == .username {
                    usernameTouched = true
                } else if focusedField == .password {
                    passwordTouched = true
                }
            }
        }
        .task {
            await viewModel.getAuthUrls()
        }
        .task(id: viewModel.chef) {
            // Check if the user signed up, but didn't verify their email yet
            if let chef = viewModel.chef, !chef.emailVerified, let router {
                await viewModel.sendVerificationEmail()
                router.navigate(to: .verifyEmail(email: chef.email))
            }
        }
    }
}

#Preview("No Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    LoginForm()
        .environment(LoginRouter())
        .environment(viewModel)
}

#Preview("Loading") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    viewModel.isLoading = true
    
    return LoginForm()
        .environment(LoginRouter())
        .environment(viewModel)
}

#Preview("No Router") {
    let mockRepo = NetworkManagerMock.shared
    let viewModel = ProfileViewModel(repository: mockRepo)
    
    return LoginForm()
        .environment(viewModel)
}
