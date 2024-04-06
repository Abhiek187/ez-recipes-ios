//
//  BoolExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 4/6/24.
//

import SwiftUI

extension Bool {
    /// Convert a bool expression into a Binding
    /// - Returns: a new bool as a Binding
    func binding() -> Binding<Bool> {
        return Binding(get: { self }, set: { _ in })
    }
}
