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
                            .foregroundColor(.black)
                            .font(.system(size: 25))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Show a spinner while the network request is loading
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    // Show previews of the HomeView with and without the spinner
    static let viewModelWithoutLoading = HomeViewModel(repository: NetworkManagerMock.shared)
    static let viewModelWithLoading = HomeViewModel(repository: NetworkManagerMock.shared)
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        
        return ForEach(Device.all, id: \.self) { device in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (No Loading)")
                .environmentObject(viewModelWithoutLoading)
            
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (Loading)")
                .environmentObject(viewModelWithLoading)
        }
    }
}
