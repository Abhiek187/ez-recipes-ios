//
//  ContentViewModelTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import XCTest
import Combine
@testable import EZ_Recipes

// Mock the network calls to fetch a hardcoded recipe
class NetworkManagerMock: RecipeRepository {
    let mockRecipe = Recipe(id: 643244, name: "Four-Ingredient Blueberry Frozen Yogurt", url: "https://spoonacular.com/four-ingredient-blueberry-frozen-yogurt-643244", image: "https://spoonacular.com/recipeImages/643244-312x231.jpg", credit: Optional("Foodista.com – The Cooking Encyclopedia Everyone Can Edit"), sourceUrl: "https://www.foodista.com/recipe/4BG3FVST/four-ingredient-blueberry-frozen-yogurt", healthScore: 8, time: 45, servings: 2, summary: "Need a <b>gluten free, lacto ovo vegetarian, and primal dessert</b>? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with <b>162 calories</b>, <b>5g of protein</b>, and <b>1g of fat</b> each. For <b>$1.98 per serving</b>, this recipe <b>covers 9%</b> of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>approximately 45 minutes</b>. Overall, this recipe earns a <b>pretty good spoonacular score of 47%</b>. <a href=\"https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026\">Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection</a>, <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219\">Blueberry Frozen Yogurt</a>, and <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795\">Blueberry Frozen Yogurt</a> are very similar to this recipe.", nutrients: [Nutrient(name: "Calories", amount: 159.52, unit: "kcal"), Nutrient(name: "Fat", amount: 0.62, unit: "g"), Nutrient(name: "Saturated Fat", amount: 0.08, unit: "g"), Nutrient(name: "Carbohydrates", amount: 36.41, unit: "g"), Nutrient(name: "Fiber", amount: 3.56, unit: "g"), Nutrient(name: "Sugar", amount: 27.91, unit: "g"), Nutrient(name: "Protein", amount: 4.54, unit: "g"), Nutrient(name: "Cholesterol", amount: 1.67, unit: "mg"), Nutrient(name: "Sodium", amount: 15.32, unit: "mg")], ingredients: [Ingredient(id: 9050, name: "blueberries", amount: 1.0, unit: "cups"), Ingredient(id: 1011256, name: "non-fat greek yogurt", amount: 0.17, unit: "cup"), Ingredient(id: 19911, name: "maple syrup", amount: 1.0, unit: "Tbs"), Ingredient(id: 9152, name: "lemon juice", amount: 0.25, unit: "Tbs")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Place all the ingredients in a food processor or blender and mix until smooth. If you want the frozen yogurt to taste more like a sorbet, add a tiny bit more of lemon juice.", ingredients: [StepItem(id: 93629, name: "frozen yogurt", image: "frozen-yogurt.png"), StepItem(id: 9152, name: "lemon juice", image: "lemon-juice.jpg"), StepItem(id: 93691, name: "sorbet", image: "sorbet.png")], equipment: [StepItem(id: 404771, name: "food processor", image: "food-processor.png"), StepItem(id: 404726, name: "blender", image: "blender.png")]), Step(number: 2, step: "Serve immediately with your favorite toppings.", ingredients: [], equipment: [])])])
    
    func getRandomRecipe() async -> Result<Recipe, Error> {
        return .success(mockRecipe)
    }
    
    func getRecipe(byId id: String) async -> Result<Recipe, Error> {
        return .success(mockRecipe)
    }
}

class ContentViewModelTests: XCTestCase {
    let mockRepo = NetworkManagerMock()
    var viewModel: HomeViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        viewModel = HomeViewModel(repository: mockRepo)
    }
    
    @MainActor func testGetRandomRecipe() {
        // Given a ViewModel
        // When the getRandomRecipe() method is called
        // Then the recipe property should be updated
        let expectation = XCTestExpectation(description: "Fetch a random recipe")
        
        // Observe when the recipe property changes and fulfill the expectation if it's set to the mock recipe
        viewModel.$recipe.sink { [weak self] recipe in
            if recipe == self?.mockRepo.mockRecipe {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable) // automatically deallocate the subscription once the sink finishes
        
        viewModel.getRandomRecipe()
        wait(for: [expectation], timeout: 1)
    }
    
    @MainActor func testGetRecipeById() {
        // Given a ViewModel
        // When the getRecipe(byId:) method is called
        // Then the recipe property should be updated
        let expectation = XCTestExpectation(description: "Fetch a recipe by its ID")
        
        viewModel.$recipe.sink { [weak self] recipe in
            if recipe == self?.mockRepo.mockRecipe {
                expectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.getRecipe(byId: "1")
        wait(for: [expectation], timeout: 1)
    }
}
