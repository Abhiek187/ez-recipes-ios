//
//  SearchViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/9/24.
//

import Foundation

@MainActor
class SearchViewModel: ViewModel, ObservableObject {
    @Published var isLoading = false
    @Published var recipeFilter = RecipeFilter()
    
    @Published var isRecipeLoaded = false
    @Published var noRecipesFound = false
    @Published private(set) var lastToken: String? = nil
    @Published private(set) var recipes: [Recipe] = [] {
        didSet {
            isRecipeLoaded = !recipes.isEmpty
            noRecipesFound = recipes.isEmpty
        }
    }
    
    @Published var recipeFailedToLoad = false
    @Published private(set) var recipeError: RecipeError? {
        didSet {
            recipeFailedToLoad = recipeError != nil
        }
    }
    
    private var repository: RecipeRepository
    
    required init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func searchRecipes(withPagination paginate: Bool = false) async {
        noRecipesFound = false
        recipeFilter.token = paginate ? lastToken : nil
        
        isLoading = true
        let result = await repository.getRecipes(withFilter: recipeFilter)
        isLoading = false
        
        switch result {
        case .success(let recipes):
            // Append results if paginating, replace otherwise
            if paginate {
                self.recipes.append(contentsOf: recipes)
            } else {
                self.recipes = recipes
            }
            
            self.recipeError = nil
            // Prevent subsequent calls if there are no more results
            lastToken = recipes.last?.token ?? recipes.last?._id
        case .failure(let recipeError):
            self.recipes = []
            self.recipeError = recipeError
        }
    }
}
