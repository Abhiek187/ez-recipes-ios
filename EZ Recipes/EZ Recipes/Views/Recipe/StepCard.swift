//
//  StepCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct StepCard: View {
    var step: Step
    
    let columns = [
        GridItem(.adaptive(minimum: 100), alignment: .top)
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // Step number & text
            HStack(spacing: 32) {
                Text("\(step.number)")
                    .font(.title)
                    .background(
                        Circle()
                            .stroke(.foreground, lineWidth: 1)
                            .frame(width: 50) // the radius will be capped at the appropriate max
                    )
                Text(step.step)
            }
            // Align all items to the start
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !step.ingredients.isEmpty {
                Divider()
                
                // Ingredients for the step
                HStack(spacing: 8) {
                    Text(Constants.RecipeView.ingredients)
                        .font(.headline.bold())
                        .padding(.trailing)
                    
                    // Wrap items if they can't fit in one row
                    LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                        ForEach(step.ingredients, id: \.id) { ingredient in
                            VStack {
                                // Scale the height to fit the width of the frame so it doesn't overlap the text
                                AsyncImage(url: Constants.RecipeView.ingredientUrl(ingredient.image))
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                                
                                Text(ingredient.name)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            if !step.equipment.isEmpty {
                Divider()
                
                // Equipment for the step
                HStack(spacing: 8) {
                    Text(Constants.RecipeView.equipment)
                        .font(.headline.bold())
                        .padding(.trailing)
                    
                    LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                        ForEach(step.equipment, id: \.id) { equipment in
                            VStack {
                                AsyncImage(url: Constants.RecipeView.equipmentUrl(equipment.image))
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                                
                                Text(equipment.name)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .card()
    }
}

struct StepCard_Previews: PreviewProvider {
    static var previews: some View {
        StepCard(step: Constants.Mocks.blueberryYogurt.instructions[0].steps[0])
    }
}
