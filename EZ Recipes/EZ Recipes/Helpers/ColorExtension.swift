//
//  ColorExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

import SwiftUI

extension Color {
    /// Create a color using RGBA values
    /// - Parameters:
    ///   - hex: The RGB hex value
    ///   - alpha: The alpha value between 0 and 1, 1 by default
  init(hex: UInt, alpha: Double = 1.0) {
    let red = Double((hex >> 16) & 0xFF) / 255.0
    let green = Double((hex >> 8) & 0xFF) / 255.0
    let blue = Double(hex & 0xFF) / 255.0

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}
