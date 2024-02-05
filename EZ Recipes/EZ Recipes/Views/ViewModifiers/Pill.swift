//
//  Pill.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/4/24.
//

import SwiftUI

private struct Pill: ViewModifier {
    var background: Color
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .padding()
            .background(background)
            .clipShape(.capsule)
    }
}

extension View {
    /// Show text content in a pill (aka capsule) shape
    /// - Parameter background: the background color of the pill
    /// - Returns: the resulting View
    func pill(_ background: Color) -> some View {
        modifier(Pill(background: background))
    }
}
