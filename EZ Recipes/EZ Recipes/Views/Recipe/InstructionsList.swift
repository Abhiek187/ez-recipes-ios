//
//  InstructionsList.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct InstructionsList: View {
    @Binding var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 8) {
            Text(Constants.Strings.steps)
                .font(.title2.bold())
            
            // Split each step by instruction (if applicable)
            ForEach(recipe.instructions, id: \.name) { instruction in
                if !instruction.name.isEmpty {
                    Text(instruction.name)
                        .font(.title3)
                }
                
                // Steps per instruction
                ForEach(instruction.steps, id: \.number) { step in
                    StepCard(step: .constant(step))
                }
            }
        }
    }
}

struct InstructionsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            InstructionsList(recipe: .constant(Constants.Mocks.blueberryYogurt))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}