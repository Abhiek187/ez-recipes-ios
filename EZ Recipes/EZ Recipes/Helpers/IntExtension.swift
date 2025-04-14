//
//  IntExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 4/13/25.
//

import Foundation

extension Int {
    /// Convert an integer to a shorthand string (e.g., 1234 --> 1.2K)
    /// - Returns: The int in string format
    func shorthand() -> String {
        return self.formatted(.number
            .notation(.compactName)
            .rounded(rule: .down)
            .precision(.fractionLength(0...1))
        )
    }
}
