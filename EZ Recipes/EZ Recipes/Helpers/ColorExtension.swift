//
//  ColorExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/20/25.
//

import SwiftUI

extension Color {
  init(hex: UInt, alpha: Double = 1.0) {
    let red = Double((hex >> 16) & 0xFF) / 255.0
    let green = Double((hex >> 8) & 0xFF) / 255.0
    let blue = Double(hex & 0xFF) / 255.0

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}
