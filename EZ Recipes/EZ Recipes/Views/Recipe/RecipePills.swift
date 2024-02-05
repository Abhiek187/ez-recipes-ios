//
//  RecipePill.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/4/24.
//

import SwiftUI

struct RecipePills: View {
    @Binding var spiceLevel: SpiceLevel
    @Binding var isVegetarian: Bool
    @Binding var isVegan: Bool
    @Binding var isGlutenFree: Bool
    @Binding var isHealthy: Bool
    @Binding var isCheap: Bool
    @Binding var isSustainable: Bool
    
    let columns = [
        GridItem(.adaptive(minimum: 100), alignment: .top)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
            if [.spicy, .mild].contains(spiceLevel) {
                Text(spiceLevel == .spicy ? "Spicy" : "Mild")
                    .pill(spiceLevel == .spicy ? .red : .orange)
                    .foregroundStyle(spiceLevel == .spicy ? .white : .black)
            }
            if isVegetarian {
                Text("Vegetarian")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isVegan {
                Text("Vegan")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isGlutenFree {
                Text("Gluten-Free")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isHealthy {
                Text("Healthy")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isCheap {
                Text("Cheap")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isSustainable {
                Text("Sustainable")
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview("Spicy") {
    RecipePills(spiceLevel: .constant(.spicy), isVegetarian: .constant(true), isVegan: .constant(true), isGlutenFree: .constant(true), isHealthy: .constant(true), isCheap: .constant(true), isSustainable: .constant(true))
}

#Preview("Mild") {
    RecipePills(spiceLevel: .constant(.mild), isVegetarian: .constant(true), isVegan: .constant(false), isGlutenFree: .constant(true), isHealthy: .constant(false), isCheap: .constant(false), isSustainable: .constant(false))
}

#Preview("No Spice") {
    RecipePills(spiceLevel: .constant(.unknown), isVegetarian: .constant(false), isVegan: .constant(false), isGlutenFree: .constant(false), isHealthy: .constant(false), isCheap: .constant(true), isSustainable: .constant(false))
}
