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
                Text(Constants.Strings.summary)
                    .font(.title2.bold())
                Spacer()
                Image(systemName: "lightbulb")
                    .accessibilityHidden(true) // make the image decorative
            }
            
            //HTMLText(recipe.summary)
            // Remove all HTML tags from the string
            Text(summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
            
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

struct SummaryBox_Previews: PreviewProvider {
    static var previews: some View {
        SummaryBox(summary: Constants.Mocks.blueberryYogurt.summary)
    }
}
