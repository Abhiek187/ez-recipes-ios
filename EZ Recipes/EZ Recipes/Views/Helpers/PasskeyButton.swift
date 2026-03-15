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
            HStack(spacing: 12) {
                Image(systemName: "person.badge.key.fill")
                    .accessibilityHidden(true)
                Text(text)
            }
        }
        .disabled(!enabled)
    }
}

#Preview {
    PasskeyButton(text: Constants.ProfileView.passkeySignIn) {}
}
