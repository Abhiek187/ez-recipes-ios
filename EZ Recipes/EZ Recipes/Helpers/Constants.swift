//
//  Constants.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Foundation

struct Constants {
    static let recipeBaseUrl = "https://ez-recipes-server.onrender.com/api/recipes"
    
    struct Mocks {
        static let mockRecipe = Recipe(id: 643244, name: "Four-Ingredient Blueberry Frozen Yogurt", url: "https://spoonacular.com/four-ingredient-blueberry-frozen-yogurt-643244", image: "https://spoonacular.com/recipeImages/643244-312x231.jpg", credit: Optional("Foodista.com – The Cooking Encyclopedia Everyone Can Edit"), sourceUrl: "https://www.foodista.com/recipe/4BG3FVST/four-ingredient-blueberry-frozen-yogurt", healthScore: 8, time: 45, servings: 2, summary: "Need a <b>gluten free, lacto ovo vegetarian, and primal dessert</b>? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with <b>162 calories</b>, <b>5g of protein</b>, and <b>1g of fat</b> each. For <b>$1.98 per serving</b>, this recipe <b>covers 9%</b> of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>approximately 45 minutes</b>. Overall, this recipe earns a <b>pretty good spoonacular score of 47%</b>. <a href=\"https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026\">Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection</a>, <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219\">Blueberry Frozen Yogurt</a>, and <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795\">Blueberry Frozen Yogurt</a> are very similar to this recipe.", nutrients: [Nutrient(name: "Calories", amount: 159.52, unit: "kcal"), Nutrient(name: "Fat", amount: 0.62, unit: "g"), Nutrient(name: "Saturated Fat", amount: 0.08, unit: "g"), Nutrient(name: "Carbohydrates", amount: 36.41, unit: "g"), Nutrient(name: "Fiber", amount: 3.56, unit: "g"), Nutrient(name: "Sugar", amount: 27.91, unit: "g"), Nutrient(name: "Protein", amount: 4.54, unit: "g"), Nutrient(name: "Cholesterol", amount: 1.67, unit: "mg"), Nutrient(name: "Sodium", amount: 15.32, unit: "mg")], ingredients: [Ingredient(id: 9050, name: "blueberries", amount: 1.0, unit: "cups"), Ingredient(id: 1011256, name: "non-fat greek yogurt", amount: 0.17, unit: "cup"), Ingredient(id: 19911, name: "maple syrup", amount: 1.0, unit: "Tbs"), Ingredient(id: 9152, name: "lemon juice", amount: 0.25, unit: "Tbs")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Place all the ingredients in a food processor or blender and mix until smooth. If you want the frozen yogurt to taste more like a sorbet, add a tiny bit more of lemon juice.", ingredients: [StepItem(id: 93629, name: "frozen yogurt", image: "frozen-yogurt.png"), StepItem(id: 9152, name: "lemon juice", image: "lemon-juice.jpg"), StepItem(id: 93691, name: "sorbet", image: "sorbet.png")], equipment: [StepItem(id: 404771, name: "food processor", image: "food-processor.png"), StepItem(id: 404726, name: "blender", image: "blender.png")]), Step(number: 2, step: "Serve immediately with your favorite toppings.", ingredients: [], equipment: [])])])
        
        static let mockRecipeError = RecipeError(error: "You are not authorized. Please read https://spoonacular.com/food-api/docs#Authentication")
    }
    
    struct Strings {
        // Home view
        static let homeTitle = "Home"
        static let findRecipeButton = "Find Me a Recipe!"
        static let errorTitle = "Error"
        static let unknownError = "Something went terribly wrong. Please submit a bug report to https://github.com/Abhiek187/ez-recipes-ios/issues"
        static let okButton = "OK"
        
        // Recipe view
        static let recipeTitle = "Recipe"
        static let noRecipe = "No recipe loaded"
        static let favoriteAlt = "Favorite this recipe"
        static let unFavoriteAlt = "Un-favorite this recipe"
        static let shareAlt = "Share this recipe"
        static let shareBody = "Check out this low-effort recipe!"
        
        // String format specifiers: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
        static let imageCopyright = "Image © %@"
        // strings dict used for plurals
        static let recipeTime = NSLocalizedString("Time: %d minute(s)", comment: "recipe time")
        static let madeButton = "I Made This!"
        static let showRecipeButton = "Show Me Another Recipe!"
        
        static let nutritionFacts = "Nutrition Facts"
        static let healthScore = "Health Score: %d%%"
        static let servings = NSLocalizedString("%d serving(s)", comment: "servings")
        static let calories = "Calories"
        static let fat = "Fat"
        static let saturatedFat = "Saturated Fat"
        static let carbohydrates = "Carbohydrates"
        static let fiber = "Fiber"
        static let sugar = "Sugar"
        static let protein = "Protein"
        static let cholesterol = "Cholesterol"
        static let sodium = "Sodium"
        
        static let summary = "Summary"
        static let ingredients = "Ingredients"
        static let steps = "Steps"
        static let equipment = "Equipment"
        static let attribution = "Powered by spoonacular"
    }
}
