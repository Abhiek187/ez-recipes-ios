//
//  RecipeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import SwiftUI

struct RecipeView: View {
    var homeViewModel: HomeViewModel
    var profileViewModel: ProfileViewModel
    @State var isFavorite = false
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                if let recipe = homeViewModel.recipe {
                    // Since the ViewModel owns the recipe, all child views should bind to the recipe object to respond to updates
                    RecipeTitle(recipe: recipe)
                    
                    // Show views side-by-side if the screen is wide enough
                    if sizeClass == .compact {
                        RecipeHeader(recipe: recipe, isLoading: homeViewModel.isLoading) {
                            // When the show another recipe button is tapped, load a new recipe in the same view
                            await homeViewModel.getRandomRecipe()
                        }
                        NutritionLabel(recipe: recipe)
                    } else {
                        HStack {
                            Spacer()
                            RecipeHeader(recipe: recipe, isLoading: homeViewModel.isLoading) {
                                await homeViewModel.getRandomRecipe()
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
                    // Shouldn't be seen normally
                    Text(Constants.RecipeView.noRecipe)
                        .onAppear {
                            // Pop to the search results if editing the filter form from the sidebar
                            dismiss()
                        }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle(Constants.RecipeView.recipeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // If logged in, save recipe to chef's profile. Otherwise, save to temporary storage.
            if let recipe = homeViewModel.recipe {
                await profileViewModel.updateViews(forRecipe: recipe)
            }
        }
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
                        item: Constants.RecipeView.shareUrl(homeViewModel.recipe?.id ?? 0),
                        subject: Text(homeViewModel.recipe?.name ?? Constants.RecipeView.unknownRecipe),
                        message: Text(Constants.RecipeView.shareBody(homeViewModel.recipe?.name ?? Constants.RecipeView.unknownRecipe))
                    )
                }
            }
        }
    }
}

#Preview {
    let repository = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let homeViewModel = HomeViewModel(repository: repository, swiftData: swiftData)
    let profileViewModel = ProfileViewModel(repository: repository, swiftData: swiftData)
    
    return NavigationStack {
        RecipeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
    }
    .task {
        await homeViewModel.getRandomRecipe()
    }
}
