//
//  InstructionsList.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/23/22.
//

import SwiftUI

struct InstructionsList: View {
    var instructions: [Instruction]
    @State private var availableWidth: CGFloat = 0
    private let cardBreakpoint: CGFloat = 832
    
    var body: some View {
        VStack(spacing: 8) {
            Text(Constants.RecipeView.steps)
                .font(.title2.bold())
            
            // Split each step by instruction (if applicable)
            ForEach(instructions, id: \.name) { instruction in
                if !instruction.name.isEmpty {
                    Text(instruction.name)
                        .font(.title3)
                }
                
                // Steps per instruction
                VStack {
                    // Using grids is more efficient than using nested lazy grids, but need to handle the grid layout ourselves
                    let cardsPerRow = availableWidth >= cardBreakpoint ? 2 : 1
                    let rowCount = (instruction.steps.count + cardsPerRow - 1) / cardsPerRow

                    Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                        ForEach(0..<rowCount, id: \.self) { row in
                            GridRow {
                                let start = row * cardsPerRow
                                // Stop once we reach the last step
                                let end = min(start + cardsPerRow, instruction.steps.count)
                                let stepSlice = instruction.steps[start..<end]

                                ForEach(Array(stepSlice), id: \.number) { step in
                                    StepCard(step: step)
                                }
                            }
                        }
                    }
                }
                // Hidden width checker
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                availableWidth = proxy.size.width
                            }
                            .onChange(of: proxy.size.width) { _, newWidth in
                                availableWidth = newWidth
                            }
                    }
                )
            }
        }
    }
}

#Preview {
    InstructionsList(instructions: Constants.Mocks.blueberryYogurt.instructions)
}
