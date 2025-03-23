//
//  SecureTextField.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/22/25.
//

import SwiftUI

/// Add an eye button to toggle the visibility of text in a secure field
/// 
/// Source: https://stackoverflow.com/a/69570555
struct SecureTextField: View {
    @State var label: String
    @Binding var text: String
    @State var isNewPassword = false
    
    @FocusState private var focusedField: Bool
    @State private var showPassword = false

    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                // Visible when showPassword = true
                TextField(label, text: $text)
                    .modifier(PasswordModifier())
                    .textContentType(isNewPassword ? .newPassword : .password)
                    .focused($focusedField, equals: showPassword)
                    .opacity(showPassword ? 1 : 0)
                // Visible when showPassword = false
                SecureField(label, text: $text)
                    .modifier(PasswordModifier())
                    .textContentType(isNewPassword ? .newPassword : .password)
                    .focused($focusedField, equals: !showPassword)
                    .opacity(showPassword ? 0 : 1)
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .padding()
                }
            }
        }
    }
}

private struct PasswordModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1)
            }
    }
}

#Preview {
    @Previewable @State var password = ""
    
    SecureTextField(label: Constants.ProfileView.passwordField, text: $password)
        .padding()
}
