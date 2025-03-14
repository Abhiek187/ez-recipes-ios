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
                Text(spiceLevel.rawValue.capitalized)
                    .pill(spiceLevel == .spicy ? .red : .orange)
                    .foregroundStyle(.black)
            }
            if isVegetarian {
                Text(Constants.SearchView.vegetarianLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isVegan {
                Text(Constants.SearchView.veganLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isGlutenFree {
                Text(Constants.SearchView.glutenFreeLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isHealthy {
                Text(Constants.SearchView.healthyLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isCheap {
                Text(Constants.SearchView.cheapLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
            if isSustainable {
                Text(Constants.SearchView.sustainableLabel)
                    .pill(.cyan)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview("Spicy") {
    RecipePills(spiceLevel: .spicy, isVegetarian: true, isVegan: true, isGlutenFree: true, isHealthy: true, isCheap: true, isSustainable: true)
}

#Preview("Mild") {
    RecipePills(spiceLevel: .mild, isVegetarian: true, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false)
}

#Preview("No Spice") {
    RecipePills(spiceLevel: .unknown, isVegetarian: false, isVegan: false, isGlutenFree: false, isHealthy: false, isCheap: true, isSustainable: false)
}
