//
//  ContentViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Foundation

// MainActor ensures UI changes happen on the main thread
@MainActor
class ContentViewModel: ObservableObject {
    // Don't allow the View to make changes to the ViewModel
    @Published private(set) var recipe: Recipe?
    
    private var repository: NetworkManager
    
    init(repository: NetworkManager) {
        self.repository = repository
    }
    
    func getRandomRecipe() {
        Task {
            let result = await repository.getRandomRecipe()
            
            switch result {
            case .success(let recipe):
                self.recipe = recipe
                print(recipe)
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
                print(recipe)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
