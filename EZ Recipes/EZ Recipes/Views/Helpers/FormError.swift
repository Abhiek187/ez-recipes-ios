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
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    @Previewable @State var showError = false
    
    VStack(spacing: 16) {
        Button("Toggle Error") {
            withAnimation {
                showError.toggle()
            }
        }
        FormError(on: showError, message: "Error message")
    }
}
