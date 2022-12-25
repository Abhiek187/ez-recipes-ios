//
//  DoubleExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import Foundation

extension Double {
    /// Round to a specified number of decimal places, add commas, and remove trailing zeros
    ///
    /// Uses the answer from https://stackoverflow.com/a/30664610, with https://stackoverflow.com/a/29560976 as a fallback
    /// - Parameter maxDigits: the number of decimal places to round to; if `0`, rounds to the nearest whole number
    /// - Returns: The rounded number as a String
    func round(to maxDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        // Keep a leading zero if |self| < 1
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxDigits
        formatter.numberStyle = .decimal // add commas
        
        // Use schoolbook rounding before removing zeros if rounding to a whole number
        var num = self
        
        if maxDigits == 0 {
            num = num.rounded()
        }
        
        return formatter.string(from: num as NSNumber) ?? String(format: "%g", num)
    }
}
