//
//  PasskeyButton.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/14/26.
//

import SwiftUI

struct PasskeyButton: View {
    var text: String
    var enabled = true
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Label(text, systemImage: "person.badge.key.fill")
                .font(.headline)
                .padding(2)
                .foregroundStyle(.primary)
        }
        .disabled(!enabled)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    PasskeyButton(text: Constants.ProfileView.passkeySignIn) {}
}
