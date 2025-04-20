//
//  HomeAccordions.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 4/19/25.
//

import SwiftUI

struct HomeAccordions: View {
    var homeViewModel: HomeViewModel
    var profileViewModel: ProfileViewModel
    
    private struct ToggleStates {
        var expandFavorites = false
        var expandRecents = false
        var expandRatings = false
    }
    @State private var toggleStates = ToggleStates()
    
    private func recipeCard(_ recipe: Recipe) -> some View {
        RecipeCard(recipe: recipe, profileViewModel: profileViewModel)
            .frame(width: 350)
            .simultaneousGesture(TapGesture().onEnded {
                // Show the recipe cards animating to the right position after tapping them
                withAnimation {
                    homeViewModel.setRecipe(recipe)
                }
            })
    }
    
    private func recipeCardLoader() -> some View {
        RecipeCard(recipe: Constants.Mocks.blueberryYogurt, profileViewModel: profileViewModel)
            .frame(width: 350)
            .redacted(reason: .placeholder)
            .disabled(true)
    }
    
    private func loadRecipeCards(_ recipes: [Recipe?], showWhenOffline: Bool = false) -> some View {
        let isLoggedIn = profileViewModel.authState == .authenticated
        let isFetchingChef = profileViewModel.authState == .loading
        
        return Group {
            if !isLoggedIn {
                if showWhenOffline {
                    // Show what's stored on the device while the chef isn't signed in
                    if homeViewModel.recentRecipes.isEmpty {
                        Text(Constants.noResults)
                    } else {
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                ForEach(homeViewModel.recentRecipes, id: \.id) { recentRecipe in
                                    if let recipe: Recipe = recentRecipe.recipe.decode() {
                                        recipeCard(recipe)
                                    }
                                }
                            }
                        }
                    }
                } else if isFetchingChef {
                    // Show the recipe cards loading while waiting for both the auth state & recipes
                    recipeCardLoader()
                } else {
                    // Encourage the user to sign in to see these recipes
                    Text(Constants.HomeView.signInForRecipes)
                }
            } else if recipes.isEmpty {
                Text(Constants.noResults)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        // Can't use ForEach directly if the element type is optional
                        ForEach(Array(zip(recipes.indices, recipes)), id: \.0) { _, recipe in
                            if let recipe {
                                recipeCard(recipe)
                            } else {
                                recipeCardLoader()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(Constants.HomeView.profileFavorites, isExpanded: $toggleStates.expandFavorites) {
                loadRecipeCards(profileViewModel.favoriteRecipes)
            }
            Divider()
            DisclosureGroup(Constants.HomeView.profileRecentlyViewed, isExpanded: $toggleStates.expandRecents) {
                loadRecipeCards(profileViewModel.recentRecipes, showWhenOffline: true)
            }
            Divider()
            DisclosureGroup(Constants.HomeView.profileRatings, isExpanded: $toggleStates.expandRatings) {
                loadRecipeCards(profileViewModel.ratedRecipes)
            }
        }
        .padding()
    }
}

#Preview {
    let mockRepo = NetworkManagerMock.shared
    let swiftData = SwiftDataManager.preview
    let homeViewModel = HomeViewModel(repository: mockRepo, swiftData: swiftData)
    
    let profileViewModel = ProfileViewModel(repository: mockRepo, swiftData: swiftData)
    
    return HomeAccordions(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
}
