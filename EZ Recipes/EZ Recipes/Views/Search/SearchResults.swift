//
//  SearchResults.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct SearchResults: View {
    var searchViewModel: SearchViewModel
    let homeViewModel = HomeViewModel(repository: NetworkManager.shared)
    let profileViewModel = ProfileViewModel(repository: NetworkManager.shared)
    
    let columns = [
        GridItem(.adaptive(minimum: 350), alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(searchViewModel.recipes, id: \.id) { recipe in
                    NavigationLink(value: recipe.id) {
                        RecipeCard(recipe: recipe, profileViewModel: profileViewModel)
                    }
                    // Don't make all the text the accent color
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Populate the recipe directly without making an API call
                        homeViewModel.setRecipe(recipe)
                    })
                }
                
                // Invisible detector when the user scrolls to the bottom of the list
                // https://stackoverflow.com/a/68682309
                Color.clear
                    .frame(width: 0, height: 0, alignment: .bottom)
                    .task {
                        // Prevent multiple requests from running at once
                        if searchViewModel.lastToken != nil && !searchViewModel.isLoading {
                            await searchViewModel.searchRecipes(withPagination: true)
                        }
                    }
            }
            
            if searchViewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle(Constants.SearchView.resultsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Int.self) { _ in
            RecipeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
        }
        .task {
            await profileViewModel.getChef()
        }
    }
}

#Preview {
    let searchViewModel = SearchViewModel(repository: NetworkManagerMock.shared)
    
    return NavigationStack {
        SearchResults(searchViewModel: searchViewModel)
    }
    .task {
        await searchViewModel.searchRecipes()
    }
}
