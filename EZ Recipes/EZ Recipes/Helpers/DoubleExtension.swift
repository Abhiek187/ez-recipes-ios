//
//  DoubleExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import Foundation

extension Double {
    /// Round to the nearest whole number, add commas, and remove the decimal and trailing zeros
    ///
    /// Uses the answer from https://stackoverflow.com/a/30664610 and https://stackoverflow.com/a/29560976 as a fallback
    /// - Returns: A whole number as a String
    func whole() -> String {
        let formatter = NumberFormatter()
        // Keep a leading zero if |self| < 1
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal // add commas
        
        // Use schoolbook rounding before removing zeros
        return formatter.string(from: self.rounded() as NSNumber) ?? String(format: "%g", self.rounded())
    }
}
