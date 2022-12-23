//
//  IngredientsList.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct IngredientsList: View {
    @State var recipe: Recipe
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
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
        .frame(width: 300)
        .padding()
        // Light the background in dark mode instead of showing a shadow
        .background(
            colorScheme == .light ? AnyView(
                Rectangle()
                    .fill(.background)
                    .shadow(radius: 5)
            ) : AnyView(
                Rectangle()
                    .fill(.secondary.opacity(0.3))
            )
        )
    }
}

struct IngredientsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            IngredientsList(recipe: Constants.Mocks.mockRecipe)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
