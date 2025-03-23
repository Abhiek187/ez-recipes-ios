//
//  KeyboardNavigation.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/23/25.
//

import SwiftUI

private struct KeyboardNavigation<T: CaseIterable & Hashable>: ViewModifier {
    @FocusState.Binding var focusedField: T?
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(Constants.KeyboardNavigation.previous, systemImage: "chevron.up") {
                        focusedField = focusedField?.previous()
                    }
                    .disabled(focusedField?.isFirst != false)
                    Button(Constants.KeyboardNavigation.next, systemImage: "chevron.down") {
                        focusedField = focusedField?.next()
                    }
                    .disabled(focusedField?.isLast != false)
                    Spacer()
                    Button(Constants.KeyboardNavigation.done) {
                        focusedField = nil
                    }
                }
            }
    }
}

extension View {
    /// Add buttons above the keyboard for ease of navigation
    /// - Parameter focusedField: a binding to the `FocusState` of input fields
    /// - Returns: the resulting View
    func keyboardNavigation<T: CaseIterable & Hashable>(focusedField: FocusState<T?>.Binding) -> some View {
        modifier(KeyboardNavigation(focusedField: focusedField))
    }
}
