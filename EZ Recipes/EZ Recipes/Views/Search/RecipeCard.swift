//
//  RecipeCard.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    var profileViewModel: ProfileViewModel
    
    func getCalories() -> Nutrient? {
        return recipe.nutrients.first { $0.name == "Calories" }
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 312, maxHeight: 231)
            } placeholder: {
                ProgressView()
            }
            Divider()
            
            HStack {
                let isFavorite = profileViewModel.chef?.favoriteRecipes.contains { $0 == String(recipe.id) } == true
                
                Text(recipe.name)
                Button {
                    Task {
                        await profileViewModel.toggleFavoriteRecipe(recipeId: recipe.id, isFavorite: !isFavorite)
                    }
                } label: {
                    // Add alt text to the system image
                    Label(isFavorite ? Constants.RecipeView.unFavoriteAlt : Constants.RecipeView.favoriteAlt, systemImage: isFavorite ? "heart.fill" : "heart")
                }
                .disabled(profileViewModel.chef == nil)
            }
            .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Text(Constants.RecipeView.recipeTime(recipe.time))
                Spacer()
                if let calories = getCalories() {
                    Text("\(calories.amount.round()) \(calories.unit)")
                    Spacer()
                }
            }
        }
        .card()
    }
}

#Preview("Logged Out") {
    let mockRepo = NetworkManagerMock.shared
    let profileViewModel = ProfileViewModel(repository: mockRepo, swiftData: SwiftDataManager.preview)
    
    RecipeCard(recipe: Constants.Mocks.blueberryYogurt, profileViewModel: profileViewModel)
}

#Preview("Logged In") {
    let mockRepo = NetworkManagerMock.shared
    let profileViewModel = ProfileViewModel(repository: mockRepo, swiftData: SwiftDataManager.preview)
    profileViewModel.chef = mockRepo.mockChef
    
    return RecipeCard(recipe: Constants.Mocks.blueberryYogurt, profileViewModel: profileViewModel)
}
