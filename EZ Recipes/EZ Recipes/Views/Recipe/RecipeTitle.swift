//
//  RecipeTitle.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 1/21/23.
//

import SwiftUI

struct RecipeTitle: View {
    var recipe: Recipe
    
    var body: some View {
        // Recipe name and link
        VStack {
            Text(recipe.name.capitalized)
                .font(.title)
                .padding([.leading, .trailing])
            
            if let url = URL(string: recipe.url) {
                Link(destination: url) {
                    Label(Constants.RecipeView.recipeLinkAlt, systemImage: "link")
                }
            }
        }
        .padding(.bottom)
    }
}

struct RecipeTitle_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTitle(recipe: Constants.Mocks.blueberryYogurt)
    }
}
