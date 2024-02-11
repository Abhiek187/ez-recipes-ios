//
//  SearchView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/8/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                FilterForm(recipeFilter: $viewModel.recipeFilter) {
                    viewModel.searchRecipes()
                }
                
                SearchResults(recipes: viewModel.recipes)
            }
            .navigationTitle(Constants.SearchView.searchTitle)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static let mockNetworkManager = NetworkManagerMock.shared
    static let viewModel = SearchViewModel(repository: mockNetworkManager)
    
    static var previews: some View {
        SearchView(viewModel: viewModel)
    }
}
