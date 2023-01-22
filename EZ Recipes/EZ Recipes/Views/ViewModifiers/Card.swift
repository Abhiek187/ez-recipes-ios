//
//  Card.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

private struct Card: ViewModifier {
    var width: CGFloat?
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .frame(width: width)
            .padding() // apply padding inside the card
            // Light the background in dark mode instead of showing a shadow
            .background(
                colorScheme == .light ? AnyView(
                    Rectangle()
                        .fill(.background)
                        .shadow(radius: 5)
                ) : AnyView(
                    Rectangle()
                        .fill(.secondary)
                        .opacity(0.3)
                )
            )
            .padding() // apply padding outside the card
    }
}

// Apply the .card modifier to a SwiftUI view
extension View {
    /// Surround the SwiftUI view with a border and drop shadow
    /// - Parameter width: the width of the card, `nil` means the card will fit the screen
    /// - Returns: the resulting View
    func card(width: CGFloat? = nil) -> some View {
        modifier(Card(width: width))
    }
}
