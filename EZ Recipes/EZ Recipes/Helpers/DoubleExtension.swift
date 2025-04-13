//
//  DoubleExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import Foundation

extension Double {
    /// Round to a specified number of decimal places, add commas, and remove trailing zeros
    /// - Parameter maxDigits: the number of decimal places to round to; if `0`, rounds to the nearest whole number
    /// - Returns: The rounded number as a String
    func round(to maxDigits: Int = 0) -> String {
        return self.formatted(.number
            .rounded(rule: .toNearestOrAwayFromZero)
            .precision(.fractionLength(0...maxDigits))
        )
    }
}
