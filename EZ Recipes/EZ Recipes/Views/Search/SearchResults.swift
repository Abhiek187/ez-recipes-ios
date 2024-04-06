//
//  SearchResults.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct SearchResults: View {
    var recipes: [Recipe]
    @ObservedObject var homeViewModel = HomeViewModel(repository: NetworkManager.shared)
    
    let columns = [
        GridItem(.adaptive(minimum: 350), alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(recipes, id: \.id) { recipe in
                    NavigationLink(value: recipe.id) {
                        RecipeCard(recipe: recipe)
                    }
                    // Don't make all the text the accent color
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Populate the recipe directly without making an API call
                        homeViewModel.setRecipe(recipe)
                    })
                }
                /* When using the filter form in the sidebar with a recipe open, homeViewModel resets.
                 * This will pop the navigation path when no recipe can be shown.
                 */
                .navigationDestination(isPresented: $homeViewModel.isRecipeLoaded) {
                    RecipeView(viewModel: homeViewModel)
                }
            }
        }
        .navigationTitle(Constants.SearchView.resultsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchResults(recipes: [
                Constants.Mocks.blueberryYogurt,
                Constants.Mocks.chocolateCupcake,
                Constants.Mocks.thaiBasilChicken
            ])
        }
    }
}
