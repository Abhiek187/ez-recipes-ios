//
//  RecipeHeader.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import SwiftUI

// Workaround since ternaries must be of the same type
private extension Button {
    /// Make the backgrounds of buttons more opaque in light mode than in dark mode
    @MainActor
    @ViewBuilder
    func buttonStyle(for colorScheme: ColorScheme) -> some View {
        switch colorScheme {
        case .light:
            buttonStyle(.borderedProminent)
        case .dark:
            buttonStyle(.bordered)
        @unknown default:
            buttonStyle(.borderedProminent)
        }
    }
}

struct RecipeHeader: View {
    var recipe: Recipe
    var isLoading: Bool
    var onFindRecipeButtonTapped: () -> Void // callback to pass to the parent View
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            // Recipe image and caption
            VStack {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    // Shrink the image if too big while maintaining its aspect ratio
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 312, maxHeight: 231)
                } placeholder: {
                    ProgressView()
                }
                
                // Add a clickable link to the image source
                // Take up as many lines as needed
                Text(Constants.RecipeView.imageCopyright(recipe.credit, recipe.sourceUrl))
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Recipe info
            HStack {
                Spacer()
                RecipePills(spiceLevel: recipe.spiceLevel, isVegetarian: recipe.isVegetarian, isVegan: recipe.isVegan, isGlutenFree: recipe.isGlutenFree, isHealthy: recipe.isHealthy, isCheap: recipe.isCheap, isSustainable: recipe.isSustainable)
                Spacer()
            }
            
            // Recipe time and buttons
            VStack {
                Text(Constants.RecipeView.recipeTime(recipe.time))
                    .font(.system(size: 20))
                
                if !recipe.types.isEmpty && recipe.types != [.unknown] {
                    Text(Constants.RecipeView.mealTypes(recipe.types))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                if !recipe.culture.isEmpty && recipe.culture != [.unknown] {
                    Text(Constants.RecipeView.cuisines(recipe.culture))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                HStack {
                    Button {
                        print("Nice! Hope it was tasty!")
                    } label: {
                        Label(Constants.RecipeView.madeButton, systemImage: "fork.knife")
                    }
                    .buttonStyle(for: colorScheme)
                    .tint(.red)
                    
                    Button {
                        onFindRecipeButtonTapped()
                    } label: {
                        Label(Constants.RecipeView.showRecipeButton, systemImage: "text.book.closed")
                    }
                    .buttonStyle(for: colorScheme)
                    .tint(.yellow)
                    .foregroundStyle(colorScheme == .light ? .black : .yellow)
                    .disabled(isLoading)
                }
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
}

struct RecipeHeader_Previews: PreviewProvider {
    static var previews: some View {
        RecipeHeader(recipe: Constants.Mocks.blueberryYogurt, isLoading: false) {}
            .previewDisplayName("No Loading")
        
        RecipeHeader(recipe: Constants.Mocks.blueberryYogurt, isLoading: true) {}
            .previewDisplayName("Loading")
    }
}
