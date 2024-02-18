//
//  RecipeCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    @State var isFavorite = false
    
    func getCalories() -> Nutrient? {
        return recipe.nutrients.first(where: { $0.name == "Calories" })
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.image))
                .frame(width: 312, height: 231)
            Divider()
            
            HStack {
                Text(recipe.name)
                Button {
                    isFavorite.toggle()
                } label: {
                    // Add alt text to the system image
                    Label(isFavorite ? Constants.RecipeView.unFavoriteAlt : Constants.RecipeView.favoriteAlt, systemImage: isFavorite ? "heart.fill" : "heart")
                }
            }
            
            HStack {
                Text(Constants.RecipeView.recipeTime(recipe.time))
                if let calories = getCalories() {
                    Text("\(calories.amount) \(calories.unit)")
                }
            }
        }
        .card()
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Constants.Mocks.blueberryYogurt)
    }
}
