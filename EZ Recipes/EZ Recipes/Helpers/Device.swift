//
//  Device.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

/// A list of devices to preview simultaneously
enum Device: String, CaseIterable {
    case iPhone8 = "iPhone 8"
    case iPhone13ProMax = "iPhone 13 Pro Max"
    case iPadPro = "iPad Pro (9.7-inch)"
    
    /// An array of all the devices as strings
    static var all: [String] {
        return Device.allCases.map { $0.rawValue }
    }
}
