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
                    // Show an alert if the request failed
                    .alert("Error", isPresented: $viewModel.recipeFailedToLoad) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        // recipeError shouldn't be nil if recipeFailedToLoad is true
                        Text(viewModel.recipeError?.error ?? "Something went terribly wrong. Please submit a bug report to https://github.com/Abhiek187/ez-recipes-ios/issues")
                    }
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
    // Show previews of the HomeView with and without the spinner or an alert box
    static let repoSuccess = NetworkManagerMock.shared
    static var repoFail = NetworkManagerMock.shared
    
    static let viewModelWithoutLoading = HomeViewModel(repository: repoSuccess)
    static let viewModelWithLoading = HomeViewModel(repository: repoSuccess)
    static let viewModelWithAlert = HomeViewModel(repository: repoFail)
    
    static var previews: some View {
        viewModelWithLoading.isLoading = true
        repoFail.isSuccess = false
        
        return ForEach(Device.all, id: \.self) { device in
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (No Loading)")
                .environmentObject(viewModelWithoutLoading)
            
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (Loading)")
                .environmentObject(viewModelWithLoading)
            
            HomeView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName("\(device) (Alert)")
                .environmentObject(viewModelWithAlert)
        }
    }
}
