//
//  RecipeTitle.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 1/21/23.
//

import SwiftUI

struct RecipeTitle: View {
    @Binding var recipe: Recipe
    
    var body: some View {
        // Recipe name and link
        VStack {
            Text(recipe.name.capitalized)
                .font(.title)
                .padding([.leading, .trailing])
            
            if let url = URL(string: recipe.url) {
                Link(destination: url) {
                    Label(Constants.Strings.recipeLinkAlt, systemImage: "link")
                }
            }
        }
        .padding(.bottom)
    }
}

struct RecipeTitle_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            RecipeTitle(recipe: .constant(Constants.Mocks.blueberryYogurt))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
