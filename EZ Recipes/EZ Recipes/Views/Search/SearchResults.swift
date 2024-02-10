//
//  SearchResults.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct SearchResults: View {
    var recipes: [Recipe]
    
    var body: some View {
        VStack {
            Text("Results")
                .font(.title)
            ForEach(recipes, id: \.id) { recipe in
                RecipeCard(recipe: recipe)
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(recipes: [
            Constants.Mocks.blueberryYogurt,
            Constants.Mocks.chocolateCupcake,
            Constants.Mocks.thaiBasilChicken
        ])
    }
}
