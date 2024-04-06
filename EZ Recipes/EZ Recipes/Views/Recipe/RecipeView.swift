//
//  RecipeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import SwiftUI

struct RecipeView: View {
    // Mark as @ObservedObject when the ViewModel is mutable
    @ObservedObject var viewModel: HomeViewModel
    @State var isFavorite = false
    @State var shareText: ShareText?
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                if let recipe = viewModel.recipe {
                    // Since the ViewModel owns the recipe, all child views should bind to the recipe object to respond to updates
                    RecipeTitle(recipe: recipe)
                    
                    // Show views side-by-side if the screen is wide enough
                    if sizeClass == .compact {
                        RecipeHeader(recipe: recipe, isLoading: viewModel.isLoading) {
                            // When the show another recipe button is tapped, load a new recipe in the same view
                            viewModel.getRandomRecipe()
                        }
                        NutritionLabel(recipe: recipe)
                    } else {
                        HStack {
                            Spacer()
                            RecipeHeader(recipe: recipe, isLoading: viewModel.isLoading) {
                                viewModel.getRandomRecipe()
                            }
                            Spacer()
                            NutritionLabel(recipe: recipe)
                            Spacer()
                        }
                    }
                    
                    if sizeClass == .compact {
                        SummaryBox(summary: recipe.summary)
                        IngredientsList(ingredients: recipe.ingredients)
                    } else {
                        HStack {
                            Spacer()
                            SummaryBox(summary: recipe.summary)
                            Spacer()
                            IngredientsList(ingredients: recipe.ingredients)
                            Spacer()
                        }
                    }
                    
                    InstructionsList(instructions: recipe.instructions)
                    
                    Divider()
                    
                    RecipeFooter()
                } else {
                    Text(Constants.RecipeView.noRecipe) // shouldn't be seen normally
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle(Constants.RecipeView.recipeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Buttons on the top right of the screen
            ToolbarItemGroup {
                HStack {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        // Add alt text to the system image
                        Label(isFavorite ? Constants.RecipeView.unFavoriteAlt : Constants.RecipeView.favoriteAlt, systemImage: isFavorite ? "heart.fill" : "heart")
                    }
                    
                    ShareLink(
                        Constants.RecipeView.shareAlt,
                        item: Constants.RecipeView.shareUrl(viewModel.recipe?.id ?? 0),
                        subject: Text(viewModel.recipe?.name ?? Constants.RecipeView.unknownRecipe),
                        message: Text(Constants.RecipeView.shareBody(viewModel.recipe?.name ?? Constants.RecipeView.unknownRecipe))
                    )
                }
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static let mockNetworkManager = NetworkManagerMock.shared
    static let viewModel = HomeViewModel(repository: mockNetworkManager)
    
    static var previews: some View {
        viewModel.getRandomRecipe()
        
        return NavigationStack {
            RecipeView(viewModel: viewModel)
        }
    }
}
