//
//  ContentViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Foundation

// Ensure all ViewModels inject a repository to call the APIs
protocol ViewModel {
    associatedtype Repository
    init(repository: Repository)
}

// MainActor ensures UI changes happen on the main thread
@MainActor
class HomeViewModel: ViewModel, ObservableObject {
    // Don't allow the View to make changes to the ViewModel
    @Published private(set) var recipe: Recipe?
    
    private var repository: RecipeRepository
    
    // Utilize dependency injection for happy little tests
    // The initializer isn't isolated since the protocol doesn't require it to be in a main actor
    nonisolated required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func getRandomRecipe() {
        Task {
            let result = await repository.getRandomRecipe()
            
            switch result {
            case .success(let recipe):
                self.recipe = recipe
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getRecipe(byId id: String) {
        Task {
            let result = await repository.getRecipe(byId: id)
            
            switch result {
            case .success(let recipe):
                self.recipe = recipe
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
