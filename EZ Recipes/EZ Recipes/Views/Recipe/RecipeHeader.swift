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
    var myRating: Int? = nil
    var onFindRecipeButtonTapped: () async -> Void // callback to pass to the parent View
    var onRate: (Int) -> Void = { _ in }
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
            
            // Recipe time, views, and buttons
            VStack {
                HStack {
                    Text(Constants.RecipeView.recipeTime(recipe.time))
                        .font(.system(size: 20))
                    Spacer()
                    Label(recipe.views?.shorthand() ?? "0", systemImage: "eye.fill")
                        .accessibilityLabel(Constants.RecipeView.viewsAlt)
                        .accessibilityValue(String(recipe.views ?? 0))
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                RecipeRating(averageRating: recipe.averageRating, totalRatings: recipe.totalRatings ?? 0, myRating: myRating, onRate: onRate)
                    .padding(.bottom, 8)
                
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
                
                Button {
                    Task {
                        await onFindRecipeButtonTapped()
                    }
                } label: {
                    Label(Constants.RecipeView.showRecipeButton, systemImage: "text.book.closed")
                }
                .buttonStyle(for: colorScheme)
                .tint(.yellow)
                .foregroundStyle(colorScheme == .light ? .black : .yellow)
                .disabled(isLoading)
            }
            
            if isLoading {
                ProgressView()
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview("Blueberry Yogurt") {
    RecipeHeader(recipe: Constants.Mocks.blueberryYogurt, isLoading: false) {}
}

#Preview("Chocolate Cupcake") {
    RecipeHeader(recipe: Constants.Mocks.chocolateCupcake, isLoading: false) {}
}

#Preview("Thai Basil Chicken") {
    RecipeHeader(recipe: Constants.Mocks.thaiBasilChicken, isLoading: false) {}
}

#Preview("Loading") {
    RecipeHeader(recipe: Constants.Mocks.blueberryYogurt, isLoading: true) {}
}
