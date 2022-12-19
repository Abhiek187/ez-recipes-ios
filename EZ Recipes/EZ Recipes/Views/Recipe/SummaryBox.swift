//
//  SummaryBox.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/18/22.
//

import SwiftUI

struct SummaryBox: View {
    @State var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Text(Constants.Strings.summary)
                    .font(.title2.bold())
                Spacer()
                Image(systemName: "lightbulb")
            }
            
            //HTMLText(recipe.summary)
            // Remove all HTML tags from the string
            Text(recipe.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
            
        }
        .padding() // apply padding inside the box
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.yellow)
        )
        .padding() // apply padding outside the box
    }
}

struct SummaryBox_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            SummaryBox(recipe: Constants.Mocks.mockRecipe)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
