//
//  StepCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct StepCard: View {
    @Binding var step: Step
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
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
                    Text(Constants.Strings.ingredients)
                        .font(.headline.bold())
                        .padding(.trailing)
                    
                    // Wrap items if they can't fit in one row
                    LazyVGrid(columns: columns) {
                        ForEach(step.ingredients, id: \.id) { ingredient in
                            VStack {
                                // Scale the height to fit the width of the frame so it doesn't overlap the text
                                AsyncImage(url: Constants.Strings.ingredientUrl(ingredient.name))
                                    .frame(width: 50)
                                    .scaledToFit()
                                
                                Text(ingredient.name)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !step.equipment.isEmpty {
                Divider()
                
                // Equipment for the step
                HStack(spacing: 8) {
                    Text(Constants.Strings.equipment)
                        .font(.headline.bold())
                        .padding(.trailing)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(step.equipment, id: \.id) { equipment in
                            VStack {
                                AsyncImage(url: Constants.Strings.equipmentUrl(equipment.name))
                                    .frame(width: 50)
                                    .scaledToFit()
                                
                                Text(equipment.name)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .card()
    }
}

struct StepCard_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            StepCard(step: .constant(Constants.Mocks.blueberryYogurt.instructions[0].steps[0]))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
