//
//  IngredientsList.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct IngredientsList: View {
    var ingredients: [Ingredient]
    
    var body: some View {
        VStack(spacing: 12) {
            Text(Constants.RecipeView.ingredients)
                .font(.title2.bold())
            
            Divider()
            
            ForEach(ingredients, id: \.id) { ingredient in
                HStack {
                    Text("\(ingredient.amount.round(to: 2)) \(ingredient.unit)")
                    Spacer()
                    Text(ingredient.name.capitalized)
                }
            }
        }
        .card(width: 300)
    }
}

#Preview {
    IngredientsList(ingredients: Constants.Mocks.blueberryYogurt.ingredients)
}
