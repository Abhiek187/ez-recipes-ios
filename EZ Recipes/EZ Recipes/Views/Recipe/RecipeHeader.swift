//
//  RecipeHeader.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

struct RecipeHeader: View {
    @State var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 16) {
            // Recipe name and link
            VStack {
                Text(recipe.name)
                    .font(.title)
                
                if let url = URL(string: recipe.url) {
                    Link(destination: url) {
                        Label(Constants.Strings.recipeLinkAlt, systemImage: "link")
                    }
                }
            }
            
            // Recipe image and caption
            VStack {
                AsyncImage(url: URL(string: recipe.image))
                    .frame(width: 312, height: 231)
                
                if let credit = recipe.credit {
                    // Add a clickable link to the image source
                    // Take up as many lines as needed
                    Text(Constants.Strings.imageCopyright(credit, recipe.sourceUrl))
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Recipe time and buttons
            VStack {
                Text(Constants.Strings.recipeTime(recipe.time))
                
                HStack {
                    Button {
                        print("Nice! Hope it was tasty!")
                    } label: {
                        Label(Constants.Strings.madeButton, systemImage: "tuningfork") // TODO: find a food icon outside of SFSymbols
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button {
                        print("Finding another recipe")
                    } label: {
                        Label(Constants.Strings.showRecipeButton, systemImage: "text.book.closed")
                    }
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                }
            }
        }
    }
}

struct RecipeHeader_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            RecipeHeader(recipe: Constants.Mocks.mockRecipe)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
