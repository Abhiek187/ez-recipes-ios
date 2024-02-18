//
//  FormError.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/10/24.
//

import SwiftUI

struct FormError: View {
    var on: Bool
    var message: String
    
    var body: some View {
        if on {
            Label(message, systemImage: "exclamationmark.circle.fill")
                .font(.callout)
                .foregroundStyle(.red)
                // Animate the error sliding down when visible
                .transition(.move(edge: .bottom))
        }
    }
}

struct FormError_Previews: PreviewProvider {
    static var previews: some View {
        FormError(on: false, message: "You shouldn't see this")
        FormError(on: true, message: "Error message")
    }
}
