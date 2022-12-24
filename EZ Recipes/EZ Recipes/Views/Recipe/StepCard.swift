//
//  StepCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct StepCard: View {
    @State var step: Step
    
    var body: some View {
        VStack(spacing: 8) {
            // Step number & text
            HStack(spacing: 16) {
                Text("\(step.number)")
                    .font(.title)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.foreground, lineWidth: 1)
                    )
                Text(step.step)
            }
            
            Divider()
            
            // Ingredients for the step
            HStack(spacing: 8) {
                Text(Constants.Strings.ingredients)
                    .font(.headline.bold())
                Spacer()
                
                ForEach(step.ingredients, id: \.id) { ingredient in
                    VStack {
                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(ingredient.image)"))
                            .frame(width: 50, height: 50)
                        Text(ingredient.name)
                    }
                }
            }
            
            Divider()
            
            // Equipment for the step
            HStack(spacing: 8) {
                Text(Constants.Strings.equipment)
                    .font(.headline.bold())
                Spacer()
                
                ForEach(step.equipment, id: \.id) { equipment in
                    VStack {
                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/equipment_100x100/\(equipment.image)"))
                            .frame(width: 50, height: 50)
                        Text(equipment.name)
                    }
                }
            }
        }
        .card(width: 300)
    }
}

struct StepCard_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            StepCard(step: Constants.Mocks.blueberryYogurt.instructions[0].steps[0])
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
