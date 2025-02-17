//
//  Constants.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Foundation
import SwiftUI

struct Constants {
    static let recipesToPresentReview = 5
    static let isUITest = ProcessInfo.processInfo.arguments.contains("isUITest")
    
    // Common strings
    static let appName = "EZ Recipes"
    static let errorTitle = "Error"
    static let unknownError = "Something went terribly wrong. Please submit a bug report to https://github.com/Abhiek187/ez-recipes-ios/issues"
    static let okButton = "OK"
    static let loadingMessages = [
        "Prepping the ingredients... 🍱",
        "Preheating the oven... ⏲️",
        "Going grocery shopping... 🛒",
        "Drying the meat... 🥩",
        "Chopping onions... 😭",
        "Dicing fruit... 🍎",
        "Steaming veggies... 🥗",
        "Applying condiments... 🧂",
        "Spicing things up... 🌶️",
        "Melting the butter... 🧈",
        "Mashing the potatoes... 🥔",
        "Fluffing some rice... 🍚",
        "Mixing things up... 🥘",
        "Shaking things up... 🍲"
    ]
    
    // APIs
    static let serverBaseUrl = "https://ez-recipes-server.onrender.com"
    static let recipesPath = "/api/recipes"
    static let termsPath = "/api/terms"
    static let chefsPath = "/api/chefs"
    static let emailCooldownSeconds = 30
    
    struct Mocks {
        // Normal, no culture
        static let blueberryYogurt = Recipe(_id: "65bfdefbe939d8f4ebf971c4", id: 643244, name: "Four-Ingredient Blueberry Frozen Yogurt", url: "https://spoonacular.com/four-ingredient-blueberry-frozen-yogurt-643244", image: "https://spoonacular.com/recipeImages/643244-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/4BG3FVST/four-ingredient-blueberry-frozen-yogurt", healthScore: 8, time: 45, servings: 2, summary: "Need a <b>gluten free, lacto ovo vegetarian, and primal dessert</b>? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with <b>162 calories</b>, <b>5g of protein</b>, and <b>1g of fat</b> each. For <b>$1.98 per serving</b>, this recipe <b>covers 9%</b> of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>approximately 45 minutes</b>. Overall, this recipe earns a <b>pretty good spoonacular score of 47%</b>. <a href=\"https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026\">Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection</a>, <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219\">Blueberry Frozen Yogurt</a>, and <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795\">Blueberry Frozen Yogurt</a> are very similar to this recipe.", types: [.dessert], spiceLevel: .none, isVegetarian: true, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [], nutrients: [Nutrient(name: "Calories", amount: 159.52, unit: "kcal"), Nutrient(name: "Fat", amount: 0.62, unit: "g"), Nutrient(name: "Saturated Fat", amount: 0.08, unit: "g"), Nutrient(name: "Carbohydrates", amount: 36.41, unit: "g"), Nutrient(name: "Fiber", amount: 3.56, unit: "g"), Nutrient(name: "Sugar", amount: 27.91, unit: "g"), Nutrient(name: "Protein", amount: 4.54, unit: "g"), Nutrient(name: "Cholesterol", amount: 1.67, unit: "mg"), Nutrient(name: "Sodium", amount: 15.32, unit: "mg")], ingredients: [Ingredient(id: 9050, name: "blueberries", amount: 1.0, unit: "cups"), Ingredient(id: 1011256, name: "non-fat greek yogurt", amount: 0.17, unit: "cup"), Ingredient(id: 19911, name: "maple syrup", amount: 1.0, unit: "Tbs"), Ingredient(id: 9152, name: "lemon juice", amount: 0.25, unit: "Tbs")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Place all the ingredients in a food processor or blender and mix until smooth. If you want the frozen yogurt to taste more like a sorbet, add a tiny bit more of lemon juice.", ingredients: [StepItem(id: 93629, name: "frozen yogurt", image: "frozen-yogurt.png"), StepItem(id: 9152, name: "lemon juice", image: "lemon-juice.jpg"), StepItem(id: 93691, name: "sorbet", image: "sorbet.png")], equipment: [StepItem(id: 404771, name: "food processor", image: "food-processor.png"), StepItem(id: 404726, name: "blender", image: "blender.png")]), Step(number: 2, step: "Serve immediately with your favorite toppings.", ingredients: [], equipment: [])])])
        
        // Contains instruction name & culture
        static let chocolateCupcake = Recipe(_id: "65bfe0fde939d8f4ebff712f", id: 644783, name: "Gluten And Dairy Free Chocolate Cupcakes", url: "https://spoonacular.com/gluten-and-dairy-free-chocolate-cupcakes-644783", image: "https://spoonacular.com/recipeImages/644783-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/PDGXCHNP/gluten-and-dairy-free-chocolate-cupcakes", healthScore: 3, time: 45, servings: 4, summary: "The recipe Gluten And Dairy Free Chocolate Cupcakes can be made <b>in approximately about 45 minutes</b>. One serving contains <b>919 calories</b>, <b>15g of protein</b>, and <b>52g of fat</b>. This gluten free and fodmap friendly recipe serves 4 and costs <b>$2.23 per serving</b>. It works well as a budget friendly dessert. Not a lot of people made this recipe, and 1 would say it hit the spot. Head to the store and pick up cocoa, xanthan gum, baking soda, and a few other things to make it today. This recipe is typical of American cuisine. It is brought to you by Foodista. Overall, this recipe earns a <b>rather bad spoonacular score of 23%</b>. Similar recipes are <a href=\"https://spoonacular.com/recipes/gluten-free-dairy-free-chocolate-zucchini-cupcakes-557465\">Gluten Free Dairy Free Chocolate Zucchini Cupcakes</a>, <a href=\"https://spoonacular.com/recipes/grain-free-gluten-free-and-dairy-free-spiced-applesauce-cupcakes-615243\">Grain-free, Gluten-free and Dairy-free Spiced Applesauce Cupcakes</a>, and <a href=\"https://spoonacular.com/recipes/gluten-free-chocolate-cupcakes-made-with-garbanzo-bean-flour-my-best-gluten-free-cupcakes-to-date-518499\">Gluten-Free Chocolate Cupcakes Made With Garbanzo Bean Flour – My Best Gluten-Free Cupcakes To Date</a>.", types: [.dessert], spiceLevel: .none, isVegetarian: false, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [.American], nutrients: [Nutrient(name: "Calories", amount: 918.45, unit: "kcal"), Nutrient(name: "Fat", amount: 52.47, unit: "g"), Nutrient(name: "Saturated Fat", amount: 31.75, unit: "g"), Nutrient(name: "Carbohydrates", amount: 108.17, unit: "g"), Nutrient(name: "Fiber", amount: 12.57, unit: "g"), Nutrient(name: "Sugar", amount: 74.85, unit: "g"), Nutrient(name: "Protein", amount: 14.53, unit: "g"), Nutrient(name: "Cholesterol", amount: 279.85, unit: "mg"), Nutrient(name: "Sodium", amount: 916.11, unit: "mg")], ingredients: [Ingredient(id: 93747, name: "coconut flour", amount: 0.13, unit: "cup"), Ingredient(id: 93696, name: "tapioca flour", amount: 0.13, unit: "cup"), Ingredient(id: 18372, name: "baking soda", amount: 0.25, unit: "teaspoon"), Ingredient(id: 2047, name: "salt", amount: 0.13, unit: "teaspoon"), Ingredient(id: 93626, name: "xanthan gum", amount: 0.13, unit: "cup"), Ingredient(id: 19165, name: "cocoa", amount: 0.13, unit: "cup"), Ingredient(id: 14412, name: "water", amount: 0.25, unit: "cup"), Ingredient(id: 1123, name: "eggs", amount: 1.25, unit: ""), Ingredient(id: 2050, name: "vanilla", amount: 0.25, unit: "tablespoon"), Ingredient(id: 1001, name: "butter", amount: 2.5, unit: "tablespoons"), Ingredient(id: 19335, name: "sugar", amount: 0.25, unit: "cup"), Ingredient(id: 98848, name: "dairy free chocolate chips", amount: 0.25, unit: "cup"), Ingredient(id: 98976, name: "coconut creamer", amount: 0.13, unit: "cup"), Ingredient(id: 14214, name: "instant coffee", amount: 0.5, unit: "teaspoons")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Preheat oven to 375 degrees.", ingredients: [], equipment: [StepItem(id: 404784, name: "oven", image: "oven.jpg")]), Step(number: 2, step: "Bring the water to a boil. Stir in the cocoa until melted and set aside until it comes to room temperature.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png"), StepItem(id: 14412, name: "water", image: "water.png")], equipment: []), Step(number: 3, step: "Stir together the coconut flour, cornstarch, xanthan gum, salt, and soda.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 93626, name: "xanthan gum", image: "white-powder.jpg"), StepItem(id: 20027, name: "corn starch", image: "white-powder.jpg"), StepItem(id: 2047, name: "salt", image: "salt.jpg"), StepItem(id: 0, name: "pop", image: "")], equipment: []), Step(number: 4, step: "Mix together well. If you have a sifter go ahead and sift it to get out all the clumps. You don't want to bite into your cupcake and get a clump of coconut flour. I don't have a sifter so I used my hands to de-clump the flour the best I can.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404708, name: "sifter", image: "sifter.jpg")]), Step(number: 5, step: "Beat together the butter and sugar.", ingredients: [StepItem(id: 1001, name: "butter", image: "butter-sliced.jpg"), StepItem(id: 19335, name: "sugar", image: "sugar-in-bowl.png")], equipment: []), Step(number: 6, step: "Beat in the eggs, one at a time, then the vanilla. Scraping down the bowl as necessary.", ingredients: [StepItem(id: 1052050, name: "vanilla", image: "vanilla.jpg"), StepItem(id: 1123, name: "egg", image: "egg.png")], equipment: [StepItem(id: 404784, name: "bowl", image: "bowl.jpg")]), Step(number: 7, step: "Add the flour mixture and beat until incorporated. Again, you might need to scrape down the bowl.", ingredients: [StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 8, step: "Add in the cocoa mixture and beat until smooth. Batter will be thin.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png")], equipment: []), Step(number: 9, step: "Line a muffin tin with baking cups or spray generously with oil.", ingredients: [StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404671, name: "muffin tray", image: "muffin-tray.jpg")]), Step(number: 10, step: "Fill each cup almost to the top and bake 16-20 minutes, or until a toothpick inserted in the middle of muffin comes out clean.", ingredients: [], equipment: [StepItem(id: 404644, name: "toothpicks", image: "toothpicks.jpg"), StepItem(id: 404784, name: "oven", image: "oven.jpg")])]), Instruction(name: "Lets make the ganache icing", steps: [Step(number: 1, step: "Place chocolate chips and instant coffee in a medium sized bowl.", ingredients: [StepItem(id: 99278, name: "chocolate chips", image: "chocolate-chips.jpg"), StepItem(id: 14214, name: "instant coffee", image: "instant-coffee-or-instant-espresso.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 2, step: "Heat the creamer over medium heat until it reaches a gentle boil.", ingredients: [StepItem(id: 0, name: "coffee creamer", image: "")], equipment: []), Step(number: 3, step: "Pour the warm creamer over the chocolate and coffee, whisk until smooth.", ingredients: [StepItem(id: 19081, name: "chocolate", image: "milk-chocolate.jpg"), StepItem(id: 18139, name: "coffee creamer", image: ""), StepItem(id: 14209, name: "coffee", image: "brewed-coffee.jpg")], equipment: [StepItem(id: 404661, name: "whisk", image: "whisk.png")]), Step(number: 4, step: "Dip the top of the cupcakes in the ganache and place in refrigerator until set- 30-60 minutes.", ingredients: [StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 0, name: "dip", image: "")], equipment: [])])], totalRatings: 3, averageRating: 3.5, views: 25)
        
        // Spicy, more cultures & types
        static let thaiBasilChicken = Recipe(_id: "65bb6a8de939d8f4eba23cf0", id: 663074, name: "Thai Basil Chicken With Green Curry", url: "https://spoonacular.com/thai-basil-chicken-with-green-curry-663074", image: "https://spoonacular.com/recipeImages/663074-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/7LQHVHF2/thai-basil-chicken-with-green-curry", healthScore: 20, time: 45, servings: 4, summary: "Thai Basil Chicken With Green Curry might be just the main course you are searching for. This gluten free and dairy free recipe serves 4 and costs <b>$2.5 per serving</b>. One portion of this dish contains around <b>28g of protein</b>, <b>34g of fat</b>, and a total of <b>491 calories</b>. Only a few people made this recipe, and 1 would say it hit the spot. A mixture of chicken stock, fish sauce, curry paste, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes roughly <b>45 minutes</b>. It is an <b>affordable</b> recipe for fans of Indian food. It is brought to you by Foodista. Taking all factors into account, this recipe <b>earns a spoonacular score of 60%</b>, which is good. Users who liked this recipe also liked <a href=\"https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1522541\">Thai Basil Chicken With Green Curry</a>, <a href=\"https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1531093\">Thai Basil Chicken With Green Curry</a>, and <a href=\"https://spoonacular.com/recipes/homemade-thai-green-curry-paste-and-an-easy-thai-green-curry-909057\">Homemade Thai Green Curry Paste (And An Easy Thai Green Curry)</a>.", types: [.lunch, .mainCourse, .mainDish, .dinner], spiceLevel: .spicy, isVegetarian: false, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [.Indian, .Asian], nutrients: [Nutrient(name: "Calories", amount: 513.83, unit: "kcal"), Nutrient(name: "Fat", amount: 34.05, unit: "g"), Nutrient(name: "Saturated Fat", amount: 22.94, unit: "g"), Nutrient(name: "Carbohydrates", amount: 25.12, unit: "g"), Nutrient(name: "Fiber", amount: 3.85, unit: "g"), Nutrient(name: "Sugar", amount: 19.19, unit: "g"), Nutrient(name: "Protein", amount: 27.88, unit: "g"), Nutrient(name: "Cholesterol", amount: 72.57, unit: "mg"), Nutrient(name: "Sodium", amount: 702.45, unit: "mg")], ingredients: [Ingredient(id: 4669, name: "vegetable oil", amount: 0.5, unit: "tablespoons"), Ingredient(id: 11282, name: "onion", amount: 0.25, unit: "medium"), Ingredient(id: 11281, name: "bell pepper", amount: 0.25, unit: ""), Ingredient(id: 11215, name: "garlic", amount: 0.5, unit: "cloves"), Ingredient(id: 1055062, name: "chicken breasts", amount: 0.25, unit: "pound"), Ingredient(id: 14106, name: "chicken stock", amount: 0.06, unit: "cup"), Ingredient(id: 12117, name: "coconut milk", amount: 0.25, unit: "can"), Ingredient(id: 6179, name: "fish sauce", amount: 0.25, unit: "tablespoon"), Ingredient(id: 19334, name: "brown sugar", amount: 0.5, unit: "tablespoons"), Ingredient(id: 10093605, name: "curry paste", amount: 0.25, unit: "tablespoon"), Ingredient(id: 1102047, name: "salt and pepper", amount: 1, unit: "servings"), Ingredient(id: 2044, name: "thai basil leaves", amount: 0.06, unit: "cup"), Ingredient(id: 10511819, name: "chilies", amount: 0.5, unit: "")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Heat oil in a wok or large saut pan over medium high heat and stir fry the onion and pepper until slightly soft.", ingredients: [StepItem(id: 1002030, name: "pepper", image: "pepper.jpg"), StepItem(id: 11282, name: "onion", image: "brown-onion.png"), StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png"), StepItem(id: 404666, name: "wok", image: "wok.png")]), Step(number: 2, step: "Add the garlic and cook for 30 more seconds.", ingredients: [StepItem(id: 11215, name: "garlic", image: "garlic.png")], equipment: []), Step(number: 3, step: "Season chicken with salt and pepper, then add to pan and cook over medium high heat, stirring occasionally and adding some oil if needed, until chicken is lightly browned.", ingredients: [StepItem(id: 1102047, name: "salt and pepper", image: "salt-and-pepper.jpg"), StepItem(id: 0, name: "chicken", image: "whole-chicken.jpg"), StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png")]), Step(number: 4, step: "Deglaze the pan with wine, then add coconut milk, fish sauce, brown sugar, green curry paste, and salt and pepper to taste.", ingredients: [StepItem(id: 10093605, name: "green curry paste", image: "green-curry-paste.png"), StepItem(id: 1102047, name: "salt and pepper", image: "salt-and-pepper.jpg"), StepItem(id: 12118, name: "coconut milk", image: "coconut-milk.png"), StepItem(id: 19334, name: "brown sugar", image: "dark-brown-sugar.png"), StepItem(id: 6179, name: "fish sauce", image: "asian-fish-sauce.jpg"), StepItem(id: 14084, name: "wine", image: "red-wine.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png")]), Step(number: 5, step: "Simmer, uncovered, until sauce thickens slightly and chicken is completely cooked through, about 5 minutes.", ingredients: [StepItem(id: 0, name: "chicken", image: "whole-chicken-jpg"), StepItem(id: 0, name: "sauce", image: "")], equipment: []), Step(number: 6, step: "Stir in the Thai basil leaves, then spoon into a serving bowl.", ingredients: [StepItem(id: 2044, name: "fresh basil", image: "fresh-basil.jpg")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 7, step: "Garnish with red chilies if desired and serve with jasmine rice.", ingredients: [StepItem(id: 10120444, name: "jasmine rice", image: "rice-jasmine-cooked.jpg"), StepItem(id: 10511819, name: "red chili pepper", image: "red-chili.jpg")], equipment: [])])], totalRatings: 538, averageRating: 4.714, views: 1804)
        
        static let recipeError = RecipeError(error: "You are not authorized. Please read https://spoonacular.com/food-api/docs#Authentication")
        
        static let terms = [Term(_id: "659355351c9a1fbc3bce6618", word: "produce", definition: "food grown by farming"), Term(_id: "6593556d1c9a1fbc3bce6619", word: "mince", definition: "cut up into small pieces"), Term(_id: "659355831c9a1fbc3bce661a", word: "broil", definition: "cook, such as in an oven"), Term(_id: "659355951c9a1fbc3bce661b", word: "simmer", definition: "stay below the boiling point when heated, such as with water"), Term(_id: "659355a41c9a1fbc3bce661c", word: "al dente", definition: "(\"to the tooth\") pasta or rice that's cooked so it can be chewed")]
        
        static let chef = Chef(uid: "oJG5PZ8KIIfvQMDsQzOwDbu2m6O2", email: "test@email.com", emailVerified: true, ratings: ["641024": 5, "663849": 3], recentRecipes: ["641024": "2024-10-17T02:54:07.471Z", "663849": "2024-10-17T22:28:27.387Z"], favoriteRecipes: ["641024"], token: "e30.e30.e30")
    }
    
    @MainActor
    struct Tabs {
        static let home = Label("Home", systemImage: "house")
        static let search = Label("Search", systemImage: "magnifyingglass")
        static let glossary = Label("Glossary", systemImage: "book")
        static let profile = Label("Profile", systemImage: "person.crop.circle")
    }
    
    struct KeyboardNavigation {
        static let previous = "Previous"
        static let next = "Next"
        static let done = "Done"
    }
    
    struct HomeView {
        static let homeTitle = "Home"
        static let findRecipeButton = "Find Me a Recipe!"
        
        static let recentlyViewed = "Recently Viewed"
        static let maxRecentRecipes = 10
        
        static let profileFavorites = "💖 Favorites"
        static let profileRecentlyViewed = "⌚ Recently Viewed"
        static let profileRatings = "⭐ Ratings"
        static let accordionExpand = "Expand"
        static let accordionCollapse = "Collapse"
        static let signInForRecipes = "Sign in to view your saved recipes"
        
        // Secondary view
        static let selectRecipe = "Select a recipe from the navigation menu."
    }
    
    struct RecipeView {
        static let recipeTitle = "Recipe"
        static let noRecipe = "No recipe loaded"
        static let favoriteAlt = "Favorite this recipe"
        static let unFavoriteAlt = "Un-favorite this recipe"
        static let shareAlt = "Share this recipe"
        static let shareBody: @Sendable (String) -> String = { recipeName in
            "Check out this low-effort recipe for \(recipeName)!"
        }
        static let shareUrl: @Sendable (Int) -> URL = { recipeId in
            URL(string: "https://ez-recipes-web.onrender.com/recipe/\(recipeId)")!
        }
        static let unknownRecipe = "unknown recipe"
        
        static let recipeLinkAlt = "Open recipe source"
        // String format specifiers: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
        static let imageCopyright: @Sendable (String, String) -> LocalizedStringKey = { credit, source in
            // Substitute the format variables, then convert to a LocalizedStringKey to parse the markdown
            LocalizedStringKey(String(format: "Image © [%@](%@)", credit, source))
        }
        // strings dict used for plurals
        static let recipeTime: @Sendable (Int) -> LocalizedStringKey = { minutes in
            // String(localized:) == NSLocalizedString
            LocalizedStringKey(String(format: String(localized: "**Time:** %d minute(s)"), minutes))
        }
        static let viewsAlt = "views"
        
        static let starRatingNone = "No ratings available"
        static let starRatingAverage: @Sendable (Double) -> String = { stars in
            "Average rating: \(stars) out of 5 stars"
        }
        static let starRatingUser: @Sendable (Int) -> String = { stars in
            "Your rating: \(stars) out of 5 stars"
        }
        static let starRatingInput: @Sendable (Int) -> String = { stars in
            String(format: String(localized: "Rate %d star(s)"), stars)
        }
        static let totalRatings: @Sendable (Int) -> String = { rating in
            String(format: String(localized: "%d rating(s)"), rating)
        }
        static let ratingError = "You must be signed in to rate this recipe"
        
        static let mealTypes: @Sendable ([MealType]) -> LocalizedStringKey = { types in
            LocalizedStringKey(String(format: "**Great for:** %@", types.filter { $0 != .unknown }.map { $0.rawValue }.joined(separator: ", ")))
        }
        static let cuisines: @Sendable ([Cuisine]) -> LocalizedStringKey = { cultures in
            LocalizedStringKey(String(format: "**Cuisines:** %@", cultures.filter { $0 != .unknown }.map { $0.rawValue }.joined(separator: ", ")))
        }
        static let madeButton = "I Made This!"
        static let showRecipeButton = "Show Me Another Recipe!"
        
        static let nutritionFacts = "Nutrition Facts"
        static let healthScore: @Sendable (Int) -> String = { score in
            "Health Score: \(score)%"
        }
        static let servings: @Sendable (Int) -> String = { servings in
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
        static let ingredientUrl: @Sendable (String) -> URL? = { ingredient in
            URL(string: "https://img.spoonacular.com/ingredients_100x100/\(ingredient)")
        }
        static let steps = "Steps"
        static let equipment = "Equipment"
        static let equipmentUrl: @Sendable (String) -> URL? = { equipment in
            URL(string: "https://img.spoonacular.com/equipment_100x100/\(equipment)")
        }
        static let attribution = "Powered by spoonacular"
    }
    
    struct SearchView {
        static let searchTitle = "Search"
        
        // Secondary view
        static let searchRecipes = "Search for recipes by applying filters from the navigation menu."
        
        // Filter form
        static let querySection = "Query"
        static let queryPlaceholder = "food"
        
        static let filterSection = "Filters"
        static let minCals = 0
        static let maxCals = 2000
        static let calorieLabel = "≤ Calories ≤"
        static let calorieUnit = "kcal"
        static let calorieExceedMaxError = "Error: Calories must be ≤ 2000"
        static let calorieInvalidRangeError = "Error: Max calories cannot exceed min calories"
        
        static let vegetarianLabel = "Vegetarian"
        static let veganLabel = "Vegan"
        static let glutenFreeLabel = "Gluten-Free"
        static let healthyLabel = "Healthy"
        static let cheapLabel = "Cheap"
        static let sustainableLabel = "Sustainable"
        
        static let spiceLabel = "Spice Level"
        static let typeLabel = "Meal Type"
        static let cultureLabel = "Cuisine"
        static let applyButton = "Apply"
        static let noResults = "No recipes found"
        
        // Results
        static let resultsTitle = "Results"
    }
    
    struct GlossaryView {
        static let glossaryTitle = "Glossary"
    }
    
    struct ProfileView {
        enum Actions: String {
            case verifyEmail, changeEmail, resetPassword
        }
        
        static let profileLoading = "Getting your profile ready… 🧑‍🍳"
        static let profileHeader: @Sendable (String) -> String = { name in
            "Chef \(name)"
        }
        static let favorites: @Sendable (Int) -> String = { recipes in
            String(format: String(localized: "%d favorite(s)"), recipes)
        }
        static let recipesViewed: @Sendable (Int) -> String = { views in
            String(format: String(localized: "%d recipe(s) viewed"), views)
        }
        @MainActor static let loginMessage = LocalizedStringKey("""
        Signing up for an account is free and gives you great perks, including:
        - Saving your favorite recipes
        - Saving more than 10 recently viewed recipes
        - Rating recipes
        - Syncing recipes across the web and mobile apps
        """)
        static let login = "Login"
        static let logout = "Logout"
        static let changeEmail = "Change Email"
        static let changePassword = "Change Password"
        static let deleteAccount = "Delete Account"
        
        // Login form
        static let passwordMinLength = 8
        
        static let signInHeader = "Sign In"
        static let signInSubHeader = "Don't have an account?"
        static let usernameField = "Username"
        static let passwordField = "Password"
        static let passwordShow = "Show password"
        static let passwordHide = "Hide password"
        static let passwordForget = "Forgot password?"
        static let signInSuccess = "Signed in successfully!"
        static let signOutSuccess = "Signed out successfully!"
        
        static let signUpHeader = "Sign Up"
        static let signUpSubHeader = "Already have an account?"
        static let emailField = "Email"
        static let passwordConfirmField = "Confirm Password"
        static let fieldRequired: @Sendable (String) -> String = { field in
            "Error: \(field) is required"
        }
        static let emailInvalid = "Error: Invalid email"
        static let passwordMinLengthErr = "Password must be at least 8 characters long"
        static let passwordTooShort = "Error: Password must be at least 8 characters long"
        static let passwordMatch = "Error: Passwords do not match"

        static let emailVerifyHeader = "You're Almost There!"
        static let emailVerifyBody: @Sendable (String) -> String = { email in
        """
        We just need to verify your email before you can put on the chef's hat.
        Check your email for a magic link sent to \(email)
        
        ⚠️ We will delete accounts from our system if they're not verified within 1 week.
        """
        }
        static let emailVerifyRetryText = "Didn't receive an email?"
        static let emailVerifyRetryLink = "Resend"
        static let emailVerifySuccess = "Email verified successfully!"
        static let forgetPasswordHeader = "No problem! Enter your email so we can reset your password."
        static let submitButton = "Submit"
        static let forgetPasswordConfirm: @Sendable (String) -> String = { email in
        """
        We sent an email to \(email). Follow the instructions to reset your password.
        
        If you didn't receive an email, you may not have created an account with this email.
        """
        }
        
        static let changeEmailField = "New Email"
        static let changeEmailConfirm: @Sendable (String) -> String = { email in
            "We sent an email to \(email). Follow the instructions to change your email."
        }
        static let changeEmailSuccess = "Email updated successfully! Please sign in again."
        static let changePasswordField = "New Password"
        static let changePasswordSuccess = "Password updated successfully! Please sign in again."
        static let deleteAccountHeader = "Are You Sure?"
        static let deleteAccountSubHeader =
        """
        You will lose access to your favorite recipes.
        Enter your username to confirm.
        """
        static let deleteAccountSuccess = "Your account has been deleted."
    }
}
