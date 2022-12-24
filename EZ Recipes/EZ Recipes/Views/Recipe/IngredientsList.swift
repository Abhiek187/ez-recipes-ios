//
//  IngredientsList.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct IngredientsList: View {
    @State var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 12) {
            Text(Constants.Strings.ingredients)
                .font(.title2.bold())
            
            Divider()
            
            ForEach(recipe.ingredients, id: \.id) { ingredient in
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

struct IngredientsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            IngredientsList(recipe: Constants.Mocks.blueberryYogurt)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
