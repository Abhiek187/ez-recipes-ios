//
//  ErrorAlert.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/30/25.
//

import SwiftUI

private struct ErrorAlert: ViewModifier {
    var isPresented: Binding<Bool>
    var message: String?
    
    func body(content: Content) -> some View {
        content
            .alert(Constants.errorTitle, isPresented: isPresented) {
                Button(Constants.okButton, role: .cancel) {}
            } message: {
                Text(message ?? Constants.unknownError)
            }
    }
}

extension View {
    /// Show an alert with an error message and an OK button
    /// - Parameters:
    ///   - isPresented: a binding to a Bool determining if the alert should be shown
    ///   - message: the error message to show inside the alert; if `nil` is provided, a default error message is shown
    /// - Returns: the resulting View
    func errorAlert(isPresented: Binding<Bool>, message: String?) -> some View {
        modifier(ErrorAlert(isPresented: isPresented, message: message))
    }
}
