//
//  HomeView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import SwiftUI

struct HomeView: View {
    // Subscribe to changes in the ObservableObject and automatically update the UI
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Show the recipe view once the recipe loads in the ViewModel
                NavigationLink(destination: RecipeView(), isActive: $viewModel.isRecipeLoaded) {
                    Button {
                        viewModel.getRandomRecipe()
                    } label: {
                        Text("Find me a recipe!")
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Show a spinner while the network request is loading
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(HomeViewModel(repository: NetworkManagerMock.shared))
        }
    }
}
