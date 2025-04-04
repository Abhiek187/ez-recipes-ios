//
//  NutritionLabel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

struct NutritionLabel: View {
    var recipe: Recipe
    
    // Nutrients that should be bolded in the nutrition label
    let nutrientHeadings = ["Calories", "Fat", "Carbohydrates", "Protein"]
    
    var body: some View {
        // Nutritional information
        VStack(spacing: 8) {
            Text(Constants.RecipeView.nutritionFacts)
                .font(.title2.bold())
            
            VStack(spacing: 4) {
                Text(Constants.RecipeView.healthScore(recipe.healthScore))
                    .font(.subheadline)
                Text(Constants.RecipeView.servings(recipe.servings))
                    .font(.subheadline)
            }
            
            Divider()
            
            VStack(spacing: 12) {
                ForEach(recipe.nutrients, id: \.name) { nutrient in
                    HStack {
                        Text(nutrient.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(nutrient.amount.round()) \(nutrient.unit)")
                            .multilineTextAlignment(.trailing)
                    }
                    .font(.body.weight(nutrientHeadings.contains(nutrient.name) ? .bold : .regular))
                }
            }
        }
        .card(width: 200)
    }
}

#Preview {
    NutritionLabel(recipe: Constants.Mocks.blueberryYogurt)
}
