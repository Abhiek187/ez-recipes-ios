//
//  NutritionLabel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

struct NutritionLabel: View {
    @State var recipe: Recipe
    @Environment(\.colorScheme) var colorScheme
    
    // Nutrients that should be bolded in the nutrition label
    let nutrientHeadings = ["Calories", "Fat", "Carbohydrates", "Protein"]
    
    var body: some View {
        // Nutritional information
        VStack(spacing: 8) {
            Text(Constants.Strings.nutritionFacts)
                .font(.title2.bold())
            
            VStack(spacing: 4) {
                Text(Constants.Strings.healthScore(recipe.healthScore))
                    .font(.subheadline)
                Text(Constants.Strings.servings(recipe.servings))
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
                    // .bold(condition) and .fontWeight are only available on iOS 16
                    .font(.body.weight(nutrientHeadings.contains(nutrient.name) ? .bold : .regular))
                }
            }
        }
        .frame(width: 200)
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

struct NutritionLabel_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            NutritionLabel(recipe: Constants.Mocks.mockRecipe)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
