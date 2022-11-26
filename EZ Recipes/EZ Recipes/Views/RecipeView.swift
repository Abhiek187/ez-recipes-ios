//
//  RecipeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            if let recipe = viewModel.recipe {
                Text(recipe.name)
            } else {
                Text(Constants.Strings.noRecipe) // shouldn't be seen normally
            }
        }
        .navigationTitle(Constants.Strings.recipeTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static let mockNetworkManager = NetworkManagerMock.shared
    static let viewModel = HomeViewModel(repository: mockNetworkManager)
    
    static var previews: some View {
        viewModel.getRandomRecipe()
        
        // The preview device and display name don't work when wrapped in a NavigationView (might be a bug)
        return ForEach(Device.all, id: \.self) { device in
            RecipeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(viewModel)
        }
    }
}
