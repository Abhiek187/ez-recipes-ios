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
            AsyncImage(url: URL(string: recipe.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 312, maxHeight: 231)
            } placeholder: {
                ProgressView()
            }
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
            .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Text(Constants.RecipeView.recipeTime(recipe.time))
                Spacer()
                if let calories = getCalories() {
                    Text("\(calories.amount.round()) \(calories.unit)")
                    Spacer()
                }
            }
        }
        .card()
    }
}

#Preview {
    RecipeCard(recipe: Constants.Mocks.blueberryYogurt)
}
