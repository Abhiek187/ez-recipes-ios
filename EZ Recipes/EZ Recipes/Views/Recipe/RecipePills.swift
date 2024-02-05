//
//  RecipePill.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/4/24.
//

import SwiftUI

struct RecipePills: View {
    var spiceLevel: SpiceLevel
    var isVegetarian: Bool
    var isVegan: Bool
    var isGlutenFree: Bool
    var isHealthy: Bool
    var isCheap: Bool
    var isSustainable: Bool
    
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

struct RecipePills_Previews: PreviewProvider {
    static var previews: some View {
        RecipePills(spiceLevel: .spicy, isVegetarian: true, isVegan: true, isGlutenFree: true, isHealthy: true, isCheap: true, isSustainable: true)
            .previewDisplayName("Spicy")
        
        RecipePills(spiceLevel: .mild, isVegetarian: true, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false)
            .previewDisplayName("Mild")
        
        RecipePills(spiceLevel: .unknown, isVegetarian: false, isVegan: false, isGlutenFree: false, isHealthy: false, isCheap: true, isSustainable: false)
            .previewDisplayName("No Spice")
    }
}
