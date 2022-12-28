//
//  Constants.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Foundation
import SwiftUI

struct Constants {
    static let recipeBaseUrl = "https://ez-recipes-server.onrender.com/api/recipes"
    
    struct Mocks {
        // Normal
        static let blueberryYogurt = Recipe(id: 643244, name: "Four-Ingredient Blueberry Frozen Yogurt", url: "https://spoonacular.com/four-ingredient-blueberry-frozen-yogurt-643244", image: "https://spoonacular.com/recipeImages/643244-312x231.jpg", credit: Optional("Foodista.com – The Cooking Encyclopedia Everyone Can Edit"), sourceUrl: "https://www.foodista.com/recipe/4BG3FVST/four-ingredient-blueberry-frozen-yogurt", healthScore: 8, time: 45, servings: 2, summary: "Need a <b>gluten free, lacto ovo vegetarian, and primal dessert</b>? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with <b>162 calories</b>, <b>5g of protein</b>, and <b>1g of fat</b> each. For <b>$1.98 per serving</b>, this recipe <b>covers 9%</b> of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>approximately 45 minutes</b>. Overall, this recipe earns a <b>pretty good spoonacular score of 47%</b>. <a href=\"https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026\">Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection</a>, <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219\">Blueberry Frozen Yogurt</a>, and <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795\">Blueberry Frozen Yogurt</a> are very similar to this recipe.", nutrients: [Nutrient(name: "Calories", amount: 159.52, unit: "kcal"), Nutrient(name: "Fat", amount: 0.62, unit: "g"), Nutrient(name: "Saturated Fat", amount: 0.08, unit: "g"), Nutrient(name: "Carbohydrates", amount: 36.41, unit: "g"), Nutrient(name: "Fiber", amount: 3.56, unit: "g"), Nutrient(name: "Sugar", amount: 27.91, unit: "g"), Nutrient(name: "Protein", amount: 4.54, unit: "g"), Nutrient(name: "Cholesterol", amount: 1.67, unit: "mg"), Nutrient(name: "Sodium", amount: 15.32, unit: "mg")], ingredients: [Ingredient(id: 9050, name: "blueberries", amount: 1.0, unit: "cups"), Ingredient(id: 1011256, name: "non-fat greek yogurt", amount: 0.17, unit: "cup"), Ingredient(id: 19911, name: "maple syrup", amount: 1.0, unit: "Tbs"), Ingredient(id: 9152, name: "lemon juice", amount: 0.25, unit: "Tbs")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Place all the ingredients in a food processor or blender and mix until smooth. If you want the frozen yogurt to taste more like a sorbet, add a tiny bit more of lemon juice.", ingredients: [StepItem(id: 93629, name: "frozen yogurt", image: "frozen-yogurt.png"), StepItem(id: 9152, name: "lemon juice", image: "lemon-juice.jpg"), StepItem(id: 93691, name: "sorbet", image: "sorbet.png")], equipment: [StepItem(id: 404771, name: "food processor", image: "food-processor.png"), StepItem(id: 404726, name: "blender", image: "blender.png")]), Step(number: 2, step: "Serve immediately with your favorite toppings.", ingredients: [], equipment: [])])])
        
        // Contains instruction name
        static let chocolateCupcake = Recipe(id: 644783, name: "Gluten And Dairy Free Chocolate Cupcakes", url: "https://spoonacular.com/gluten-and-dairy-free-chocolate-cupcakes-644783", image: "https://spoonacular.com/recipeImages/644783-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/PDGXCHNP/gluten-and-dairy-free-chocolate-cupcakes", healthScore: 3, time: 45, servings: 4, summary: "The recipe Gluten And Dairy Free Chocolate Cupcakes can be made <b>in approximately about 45 minutes</b>. One serving contains <b>919 calories</b>, <b>15g of protein</b>, and <b>52g of fat</b>. This gluten free and fodmap friendly recipe serves 4 and costs <b>$2.23 per serving</b>. It works well as a budget friendly dessert. Not a lot of people made this recipe, and 1 would say it hit the spot. Head to the store and pick up cocoa, xanthan gum, baking soda, and a few other things to make it today. This recipe is typical of American cuisine. It is brought to you by Foodista. Overall, this recipe earns a <b>rather bad spoonacular score of 23%</b>. Similar recipes are <a href=\"https://spoonacular.com/recipes/gluten-free-dairy-free-chocolate-zucchini-cupcakes-557465\">Gluten Free Dairy Free Chocolate Zucchini Cupcakes</a>, <a href=\"https://spoonacular.com/recipes/grain-free-gluten-free-and-dairy-free-spiced-applesauce-cupcakes-615243\">Grain-free, Gluten-free and Dairy-free Spiced Applesauce Cupcakes</a>, and <a href=\"https://spoonacular.com/recipes/gluten-free-chocolate-cupcakes-made-with-garbanzo-bean-flour-my-best-gluten-free-cupcakes-to-date-518499\">Gluten-Free Chocolate Cupcakes Made With Garbanzo Bean Flour – My Best Gluten-Free Cupcakes To Date</a>.", nutrients: [Nutrient(name: "Calories", amount: 918.45, unit: "kcal"), Nutrient(name: "Fat", amount: 52.47, unit: "g"), Nutrient(name: "Saturated Fat", amount: 31.75, unit: "g"), Nutrient(name: "Carbohydrates", amount: 108.17, unit: "g"), Nutrient(name: "Fiber", amount: 12.57, unit: "g"), Nutrient(name: "Sugar", amount: 74.85, unit: "g"), Nutrient(name: "Protein", amount: 14.53, unit: "g"), Nutrient(name: "Cholesterol", amount: 279.85, unit: "mg"), Nutrient(name: "Sodium", amount: 916.11, unit: "mg")], ingredients: [Ingredient(id: 93747, name: "coconut flour", amount: 0.13, unit: "cup"), Ingredient(id: 93696, name: "tapioca flour", amount: 0.13, unit: "cup"), Ingredient(id: 18372, name: "baking soda", amount: 0.25, unit: "teaspoon"), Ingredient(id: 2047, name: "salt", amount: 0.13, unit: "teaspoon"), Ingredient(id: 93626, name: "xanthan gum", amount: 0.13, unit: "cup"), Ingredient(id: 19165, name: "cocoa", amount: 0.13, unit: "cup"), Ingredient(id: 14412, name: "water", amount: 0.25, unit: "cup"), Ingredient(id: 1123, name: "eggs", amount: 1.25, unit: ""), Ingredient(id: 2050, name: "vanilla", amount: 0.25, unit: "tablespoon"), Ingredient(id: 1001, name: "butter", amount: 2.5, unit: "tablespoons"), Ingredient(id: 19335, name: "sugar", amount: 0.25, unit: "cup"), Ingredient(id: 98848, name: "dairy free chocolate chips", amount: 0.25, unit: "cup"), Ingredient(id: 98976, name: "coconut creamer", amount: 0.13, unit: "cup"), Ingredient(id: 14214, name: "instant coffee", amount: 0.5, unit: "teaspoons")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Preheat oven to 375 degrees.", ingredients: [], equipment: [StepItem(id: 404784, name: "oven", image: "oven.jpg")]), Step(number: 2, step: "Bring the water to a boil. Stir in the cocoa until melted and set aside until it comes to room temperature.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png"), StepItem(id: 14412, name: "water", image: "water.png")], equipment: []), Step(number: 3, step: "Stir together the coconut flour, cornstarch, xanthan gum, salt, and soda.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 93626, name: "xanthan gum", image: "white-powder.jpg"), StepItem(id: 20027, name: "corn starch", image: "white-powder.jpg"), StepItem(id: 2047, name: "salt", image: "salt.jpg"), StepItem(id: 0, name: "pop", image: "")], equipment: []), Step(number: 4, step: "Mix together well. If you have a sifter go ahead and sift it to get out all the clumps. You don't want to bite into your cupcake and get a clump of coconut flour. I don't have a sifter so I used my hands to de-clump the flour the best I can.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404708, name: "sifter", image: "sifter.jpg")]), Step(number: 5, step: "Beat together the butter and sugar.", ingredients: [StepItem(id: 1001, name: "butter", image: "butter-sliced.jpg"), StepItem(id: 19335, name: "sugar", image: "sugar-in-bowl.png")], equipment: []), Step(number: 6, step: "Beat in the eggs, one at a time, then the vanilla. Scraping down the bowl as necessary.", ingredients: [StepItem(id: 1052050, name: "vanilla", image: "vanilla.jpg"), StepItem(id: 1123, name: "egg", image: "egg.png")], equipment: [StepItem(id: 404784, name: "bowl", image: "bowl.jpg")]), Step(number: 7, step: "Add the flour mixture and beat until incorporated. Again, you might need to scrape down the bowl.", ingredients: [StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 8, step: "Add in the cocoa mixture and beat until smooth. Batter will be thin.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png")], equipment: []), Step(number: 9, step: "Line a muffin tin with baking cups or spray generously with oil.", ingredients: [StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404671, name: "muffin tray", image: "muffin-tray.jpg")]), Step(number: 10, step: "Fill each cup almost to the top and bake 16-20 minutes, or until a toothpick inserted in the middle of muffin comes out clean.", ingredients: [], equipment: [StepItem(id: 404644, name: "toothpicks", image: "toothpicks.jpg"), StepItem(id: 404784, name: "oven", image: "oven.jpg")])]), Instruction(name: "Lets make the ganache icing", steps: [Step(number: 1, step: "Place chocolate chips and instant coffee in a medium sized bowl.", ingredients: [StepItem(id: 99278, name: "chocolate chips", image: "chocolate-chips.jpg"), StepItem(id: 14214, name: "instant coffee", image: "instant-coffee-or-instant-espresso.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 2, step: "Heat the creamer over medium heat until it reaches a gentle boil.", ingredients: [StepItem(id: 0, name: "coffee creamer", image: "")], equipment: []), Step(number: 3, step: "Pour the warm creamer over the chocolate and coffee, whisk until smooth.", ingredients: [StepItem(id: 19081, name: "chocolate", image: "milk-chocolate.jpg"), StepItem(id: 18139, name: "coffee creamer", image: ""), StepItem(id: 14209, name: "coffee", image: "brewed-coffee.jpg")], equipment: [StepItem(id: 404661, name: "whisk", image: "whisk.png")]), Step(number: 4, step: "Dip the top of the cupcakes in the ganache and place in refrigerator until set- 30-60 minutes.", ingredients: [StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 0, name: "dip", image: "")], equipment: [])])])
        
        static let recipeError = RecipeError(error: "You are not authorized. Please read https://spoonacular.com/food-api/docs#Authentication")
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
        
        static let recipeLinkAlt = "Open recipe source"
        // String format specifiers: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
        static let imageCopyright: (String, String) -> LocalizedStringKey = { credit, source in
            // Substitute the format variables, then convert to a LocalizedStringKey to parse the markdown
            LocalizedStringKey(String(format: "Image © [%@](%@)", credit, source))
        }
        // strings dict used for plurals
        static let recipeTime: (Int) -> LocalizedStringKey = { minutes in
            // String(localized:) == NSLocalizedString
            LocalizedStringKey(String(format: String(localized: "**Time:** %d minute(s)"), minutes))
        }
        static let madeButton = "I Made This!"
        static let showRecipeButton = "Show Me Another Recipe!"
        
        static let nutritionFacts = "Nutrition Facts"
        static let healthScore: (Int) -> String = { score in
            String(format: "Health Score: %d%%", score)
        }
        static let servings: (Int) -> String = { servings in
            String(format: String(localized: "%d serving(s)"), servings)
        }
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
        static let ingredientUrl: (String) -> URL? = { ingredient in
            URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(ingredient)")
        }
        static let steps = "Steps"
        static let equipment = "Equipment"
        static let equipmentUrl: (String) -> URL? = { equipment in
            URL(string: "https://spoonacular.com/cdn/equipment_100x100/\(equipment)")
        }
        static let attribution = "Powered by spoonacular"
    }
}
