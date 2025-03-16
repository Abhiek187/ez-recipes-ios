//
//  SummaryBox.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/18/22.
//

import SwiftUI

struct SummaryBox: View {
    var summary: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Text(Constants.RecipeView.summary)
                    .font(.title2.bold())
                Spacer()
                Image(systemName: "lightbulb")
                    .accessibilityHidden(true) // make the image decorative
            }
            
            Text(.init(summary.htmlToMarkdown))
                .tint(.blue) // make links easier to see in dark mode
        }
        .padding() // apply padding inside the box
        .foregroundStyle(.black)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.yellow)
        )
        .padding() // apply padding outside the box
    }
}

#Preview {
    SummaryBox(summary: Constants.Mocks.blueberryYogurt.summary)
}
