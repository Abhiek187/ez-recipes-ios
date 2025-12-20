//
//  Constants.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/22/22.
//

import Foundation
import RegexBuilder
import SwiftUI

struct Constants {
    static let recipesToPresentReview = 5
    static let isUITest = ProcessInfo.processInfo.arguments.contains("isUITest")
    
    // Common strings
    static let appName = "EZ Recipes"
    // Using localized strings for automatic translation support
    static let errorTitle = String(localized: "Error")
    static let unknownError = String(localized: "Something went terribly wrong. Please submit a bug report to https://github.com/Abhiek187/ez-recipes-ios/issues")
    static let noTokenFound = String(localized: "No token found")
    static let okButton = String(localized: "OK")
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
    ].map {
        String(localized: $0)
    }
    static let noResults = String(localized: "No recipes found")
    
    // APIs
    static let serverBaseUrl = "https://ez-recipes-server.onrender.com"
    static let baseRecipesPath = serverBaseUrl + "/api/recipes"
    static let baseTermsPath = serverBaseUrl + "/api/terms"
    static let baseChefsPath = serverBaseUrl + "/api/chefs"
    static let recipeWebOrigin = "https://ez-recipes-web.onrender.com"
    
    // Using the Android email regex since Swift doesn't allow escaping certain literals in the RFC 5322 regex: https://android.googlesource.com/platform/frameworks/base/+/cd92588/core/java/android/util/Patterns.java
    // A more readable version of: /[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+/
    @MainActor static let emailRegex = Regex {
        Repeat(1...256) {
            CharacterClass(
                .anyOf("+._%-+"),
                ("a"..."z"),
                ("A"..."Z"),
                ("0"..."9")
            )
        }
        "@"
        CharacterClass(
            ("a"..."z"),
            ("A"..."Z"),
            ("0"..."9")
        )
        Repeat(0...64) {
            CharacterClass(
                .anyOf("-"),
                ("a"..."z"),
                ("A"..."Z"),
                ("0"..."9")
            )
        }
        OneOrMore {
            Capture {
                Regex {
                    "."
                    CharacterClass(
                        ("a"..."z"),
                        ("A"..."Z"),
                        ("0"..."9")
                    )
                    Repeat(0...25) {
                        CharacterClass(
                            .anyOf("-"),
                            ("a"..."z"),
                            ("A"..."Z"),
                            ("0"..."9")
                        )
                    }
                }
            }
        }
    }
    static let emailCooldownSeconds = 30
    static let passwordMinLength = 8
    static let credentialTooOldError = "CREDENTIAL_TOO_OLD_LOGIN_AGAIN"
    
    struct Mocks {
        // Normal, no culture
        static let blueberryYogurt = Recipe(_id: "65bfdefbe939d8f4ebf971c4", id: 643244, name: "Four-Ingredient Blueberry Frozen Yogurt", url: "https://spoonacular.com/four-ingredient-blueberry-frozen-yogurt-643244", image: "https://spoonacular.com/recipeImages/643244-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/4BG3FVST/four-ingredient-blueberry-frozen-yogurt", healthScore: 8, time: 45, servings: 2, summary: "Need a <b>gluten free, lacto ovo vegetarian, and primal dessert</b>? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with <b>162 calories</b>, <b>5g of protein</b>, and <b>1g of fat</b> each. For <b>$1.98 per serving</b>, this recipe <b>covers 9%</b> of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately <b>approximately 45 minutes</b>. Overall, this recipe earns a <b>pretty good spoonacular score of 47%</b>. <a href=\"https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026\">Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection</a>, <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219\">Blueberry Frozen Yogurt</a>, and <a href=\"https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795\">Blueberry Frozen Yogurt</a> are very similar to this recipe.", types: [.dessert], spiceLevel: .none, isVegetarian: true, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [], nutrients: [Nutrient(name: "Calories", amount: 159.52, unit: "kcal"), Nutrient(name: "Fat", amount: 0.62, unit: "g"), Nutrient(name: "Saturated Fat", amount: 0.08, unit: "g"), Nutrient(name: "Carbohydrates", amount: 36.41, unit: "g"), Nutrient(name: "Fiber", amount: 3.56, unit: "g"), Nutrient(name: "Sugar", amount: 27.91, unit: "g"), Nutrient(name: "Protein", amount: 4.54, unit: "g"), Nutrient(name: "Cholesterol", amount: 1.67, unit: "mg"), Nutrient(name: "Sodium", amount: 15.32, unit: "mg")], ingredients: [Ingredient(id: 9050, name: "blueberries", amount: 1.0, unit: "cups"), Ingredient(id: 1011256, name: "non-fat greek yogurt", amount: 0.17, unit: "cup"), Ingredient(id: 19911, name: "maple syrup", amount: 1.0, unit: "Tbs"), Ingredient(id: 9152, name: "lemon juice", amount: 0.25, unit: "Tbs")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Place all the ingredients in a food processor or blender and mix until smooth. If you want the frozen yogurt to taste more like a sorbet, add a tiny bit more of lemon juice.", ingredients: [StepItem(id: 93629, name: "frozen yogurt", image: "frozen-yogurt.png"), StepItem(id: 9152, name: "lemon juice", image: "lemon-juice.jpg"), StepItem(id: 93691, name: "sorbet", image: "sorbet.png")], equipment: [StepItem(id: 404771, name: "food processor", image: "food-processor.png"), StepItem(id: 404726, name: "blender", image: "blender.png")]), Step(number: 2, step: "Serve immediately with your favorite toppings.", ingredients: [], equipment: [])])])
        
        // Contains instruction name & culture
        static let chocolateCupcake = Recipe(_id: "65bfe0fde939d8f4ebff712f", id: 644783, name: "Gluten And Dairy Free Chocolate Cupcakes", url: "https://spoonacular.com/gluten-and-dairy-free-chocolate-cupcakes-644783", image: "https://spoonacular.com/recipeImages/644783-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/PDGXCHNP/gluten-and-dairy-free-chocolate-cupcakes", healthScore: 3, time: 45, servings: 4, summary: "The recipe Gluten And Dairy Free Chocolate Cupcakes can be made <b>in approximately about 45 minutes</b>. One serving contains <b>919 calories</b>, <b>15g of protein</b>, and <b>52g of fat</b>. This gluten free and fodmap friendly recipe serves 4 and costs <b>$2.23 per serving</b>. It works well as a budget friendly dessert. Not a lot of people made this recipe, and 1 would say it hit the spot. Head to the store and pick up cocoa, xanthan gum, baking soda, and a few other things to make it today. This recipe is typical of American cuisine. It is brought to you by Foodista. Overall, this recipe earns a <b>rather bad spoonacular score of 23%</b>. Similar recipes are <a href=\"https://spoonacular.com/recipes/gluten-free-dairy-free-chocolate-zucchini-cupcakes-557465\">Gluten Free Dairy Free Chocolate Zucchini Cupcakes</a>, <a href=\"https://spoonacular.com/recipes/grain-free-gluten-free-and-dairy-free-spiced-applesauce-cupcakes-615243\">Grain-free, Gluten-free and Dairy-free Spiced Applesauce Cupcakes</a>, and <a href=\"https://spoonacular.com/recipes/gluten-free-chocolate-cupcakes-made-with-garbanzo-bean-flour-my-best-gluten-free-cupcakes-to-date-518499\">Gluten-Free Chocolate Cupcakes Made With Garbanzo Bean Flour – My Best Gluten-Free Cupcakes To Date</a>.", types: [.dessert], spiceLevel: .none, isVegetarian: false, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [.American], nutrients: [Nutrient(name: "Calories", amount: 918.45, unit: "kcal"), Nutrient(name: "Fat", amount: 52.47, unit: "g"), Nutrient(name: "Saturated Fat", amount: 31.75, unit: "g"), Nutrient(name: "Carbohydrates", amount: 108.17, unit: "g"), Nutrient(name: "Fiber", amount: 12.57, unit: "g"), Nutrient(name: "Sugar", amount: 74.85, unit: "g"), Nutrient(name: "Protein", amount: 14.53, unit: "g"), Nutrient(name: "Cholesterol", amount: 279.85, unit: "mg"), Nutrient(name: "Sodium", amount: 916.11, unit: "mg")], ingredients: [Ingredient(id: 93747, name: "coconut flour", amount: 0.13, unit: "cup"), Ingredient(id: 93696, name: "tapioca flour", amount: 0.13, unit: "cup"), Ingredient(id: 18372, name: "baking soda", amount: 0.25, unit: "teaspoon"), Ingredient(id: 2047, name: "salt", amount: 0.13, unit: "teaspoon"), Ingredient(id: 93626, name: "xanthan gum", amount: 0.13, unit: "cup"), Ingredient(id: 19165, name: "cocoa", amount: 0.13, unit: "cup"), Ingredient(id: 14412, name: "water", amount: 0.25, unit: "cup"), Ingredient(id: 1123, name: "eggs", amount: 1.25, unit: ""), Ingredient(id: 2050, name: "vanilla", amount: 0.25, unit: "tablespoon"), Ingredient(id: 1001, name: "butter", amount: 2.5, unit: "tablespoons"), Ingredient(id: 19335, name: "sugar", amount: 0.25, unit: "cup"), Ingredient(id: 98848, name: "dairy free chocolate chips", amount: 0.25, unit: "cup"), Ingredient(id: 98976, name: "coconut creamer", amount: 0.13, unit: "cup"), Ingredient(id: 14214, name: "instant coffee", amount: 0.5, unit: "teaspoons")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Preheat oven to 375 degrees.", ingredients: [], equipment: [StepItem(id: 404784, name: "oven", image: "oven.jpg")]), Step(number: 2, step: "Bring the water to a boil. Stir in the cocoa until melted and set aside until it comes to room temperature.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png"), StepItem(id: 14412, name: "water", image: "water.png")], equipment: []), Step(number: 3, step: "Stir together the coconut flour, cornstarch, xanthan gum, salt, and soda.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 93626, name: "xanthan gum", image: "white-powder.jpg"), StepItem(id: 20027, name: "corn starch", image: "white-powder.jpg"), StepItem(id: 2047, name: "salt", image: "salt.jpg"), StepItem(id: 0, name: "pop", image: "")], equipment: []), Step(number: 4, step: "Mix together well. If you have a sifter go ahead and sift it to get out all the clumps. You don't want to bite into your cupcake and get a clump of coconut flour. I don't have a sifter so I used my hands to de-clump the flour the best I can.", ingredients: [StepItem(id: 93747, name: "coconut flour", image: "coconut-flour-or-other-gluten-free-flour.jpg"), StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404708, name: "sifter", image: "sifter.jpg")]), Step(number: 5, step: "Beat together the butter and sugar.", ingredients: [StepItem(id: 1001, name: "butter", image: "butter-sliced.jpg"), StepItem(id: 19335, name: "sugar", image: "sugar-in-bowl.png")], equipment: []), Step(number: 6, step: "Beat in the eggs, one at a time, then the vanilla. Scraping down the bowl as necessary.", ingredients: [StepItem(id: 1052050, name: "vanilla", image: "vanilla.jpg"), StepItem(id: 1123, name: "egg", image: "egg.png")], equipment: [StepItem(id: 404784, name: "bowl", image: "bowl.jpg")]), Step(number: 7, step: "Add the flour mixture and beat until incorporated. Again, you might need to scrape down the bowl.", ingredients: [StepItem(id: 20081, name: "all purpose flour", image: "flour.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 8, step: "Add in the cocoa mixture and beat until smooth. Batter will be thin.", ingredients: [StepItem(id: 19165, name: "cocoa powder", image: "cocoa-powder.png")], equipment: []), Step(number: 9, step: "Line a muffin tin with baking cups or spray generously with oil.", ingredients: [StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404671, name: "muffin tray", image: "muffin-tray.jpg")]), Step(number: 10, step: "Fill each cup almost to the top and bake 16-20 minutes, or until a toothpick inserted in the middle of muffin comes out clean.", ingredients: [], equipment: [StepItem(id: 404644, name: "toothpicks", image: "toothpicks.jpg"), StepItem(id: 404784, name: "oven", image: "oven.jpg")])]), Instruction(name: "Lets make the ganache icing", steps: [Step(number: 1, step: "Place chocolate chips and instant coffee in a medium sized bowl.", ingredients: [StepItem(id: 99278, name: "chocolate chips", image: "chocolate-chips.jpg"), StepItem(id: 14214, name: "instant coffee", image: "instant-coffee-or-instant-espresso.png")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 2, step: "Heat the creamer over medium heat until it reaches a gentle boil.", ingredients: [StepItem(id: 0, name: "coffee creamer", image: "")], equipment: []), Step(number: 3, step: "Pour the warm creamer over the chocolate and coffee, whisk until smooth.", ingredients: [StepItem(id: 19081, name: "chocolate", image: "milk-chocolate.jpg"), StepItem(id: 18139, name: "coffee creamer", image: ""), StepItem(id: 14209, name: "coffee", image: "brewed-coffee.jpg")], equipment: [StepItem(id: 404661, name: "whisk", image: "whisk.png")]), Step(number: 4, step: "Dip the top of the cupcakes in the ganache and place in refrigerator until set- 30-60 minutes.", ingredients: [StepItem(id: 18139, name: "cupcakes", image: "plain-cupcake.jpg"), StepItem(id: 0, name: "dip", image: "")], equipment: [])])], totalRatings: 3, averageRating: 3.5, views: 25)
        
        // Spicy, more cultures & types
        static let thaiBasilChicken = Recipe(_id: "65bb6a8de939d8f4eba23cf0", id: 663074, name: "Thai Basil Chicken With Green Curry", url: "https://spoonacular.com/thai-basil-chicken-with-green-curry-663074", image: "https://spoonacular.com/recipeImages/663074-312x231.jpg", credit: "Foodista.com – The Cooking Encyclopedia Everyone Can Edit", sourceUrl: "https://www.foodista.com/recipe/7LQHVHF2/thai-basil-chicken-with-green-curry", healthScore: 20, time: 45, servings: 4, summary: "Thai Basil Chicken With Green Curry might be just the main course you are searching for. This gluten free and dairy free recipe serves 4 and costs <b>$2.5 per serving</b>. One portion of this dish contains around <b>28g of protein</b>, <b>34g of fat</b>, and a total of <b>491 calories</b>. Only a few people made this recipe, and 1 would say it hit the spot. A mixture of chicken stock, fish sauce, curry paste, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes roughly <b>45 minutes</b>. It is an <b>affordable</b> recipe for fans of Indian food. It is brought to you by Foodista. Taking all factors into account, this recipe <b>earns a spoonacular score of 60%</b>, which is good. Users who liked this recipe also liked <a href=\"https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1522541\">Thai Basil Chicken With Green Curry</a>, <a href=\"https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1531093\">Thai Basil Chicken With Green Curry</a>, and <a href=\"https://spoonacular.com/recipes/homemade-thai-green-curry-paste-and-an-easy-thai-green-curry-909057\">Homemade Thai Green Curry Paste (And An Easy Thai Green Curry)</a>.", types: [.lunch, .mainCourse, .mainDish, .dinner], spiceLevel: .spicy, isVegetarian: false, isVegan: false, isGlutenFree: true, isHealthy: false, isCheap: false, isSustainable: false, culture: [.Indian, .Asian], nutrients: [Nutrient(name: "Calories", amount: 513.83, unit: "kcal"), Nutrient(name: "Fat", amount: 34.05, unit: "g"), Nutrient(name: "Saturated Fat", amount: 22.94, unit: "g"), Nutrient(name: "Carbohydrates", amount: 25.12, unit: "g"), Nutrient(name: "Fiber", amount: 3.85, unit: "g"), Nutrient(name: "Sugar", amount: 19.19, unit: "g"), Nutrient(name: "Protein", amount: 27.88, unit: "g"), Nutrient(name: "Cholesterol", amount: 72.57, unit: "mg"), Nutrient(name: "Sodium", amount: 702.45, unit: "mg")], ingredients: [Ingredient(id: 4669, name: "vegetable oil", amount: 0.5, unit: "tablespoons"), Ingredient(id: 11282, name: "onion", amount: 0.25, unit: "medium"), Ingredient(id: 11281, name: "bell pepper", amount: 0.25, unit: ""), Ingredient(id: 11215, name: "garlic", amount: 0.5, unit: "cloves"), Ingredient(id: 1055062, name: "chicken breasts", amount: 0.25, unit: "pound"), Ingredient(id: 14106, name: "chicken stock", amount: 0.06, unit: "cup"), Ingredient(id: 12117, name: "coconut milk", amount: 0.25, unit: "can"), Ingredient(id: 6179, name: "fish sauce", amount: 0.25, unit: "tablespoon"), Ingredient(id: 19334, name: "brown sugar", amount: 0.5, unit: "tablespoons"), Ingredient(id: 10093605, name: "curry paste", amount: 0.25, unit: "tablespoon"), Ingredient(id: 1102047, name: "salt and pepper", amount: 1, unit: "servings"), Ingredient(id: 2044, name: "thai basil leaves", amount: 0.06, unit: "cup"), Ingredient(id: 10511819, name: "chilies", amount: 0.5, unit: "")], instructions: [Instruction(name: "", steps: [Step(number: 1, step: "Heat oil in a wok or large saut pan over medium high heat and stir fry the onion and pepper until slightly soft.", ingredients: [StepItem(id: 1002030, name: "pepper", image: "pepper.jpg"), StepItem(id: 11282, name: "onion", image: "brown-onion.png"), StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png"), StepItem(id: 404666, name: "wok", image: "wok.png")]), Step(number: 2, step: "Add the garlic and cook for 30 more seconds.", ingredients: [StepItem(id: 11215, name: "garlic", image: "garlic.png")], equipment: []), Step(number: 3, step: "Season chicken with salt and pepper, then add to pan and cook over medium high heat, stirring occasionally and adding some oil if needed, until chicken is lightly browned.", ingredients: [StepItem(id: 1102047, name: "salt and pepper", image: "salt-and-pepper.jpg"), StepItem(id: 0, name: "chicken", image: "whole-chicken.jpg"), StepItem(id: 4582, name: "cooking oil", image: "vegetable-oil.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png")]), Step(number: 4, step: "Deglaze the pan with wine, then add coconut milk, fish sauce, brown sugar, green curry paste, and salt and pepper to taste.", ingredients: [StepItem(id: 10093605, name: "green curry paste", image: "green-curry-paste.png"), StepItem(id: 1102047, name: "salt and pepper", image: "salt-and-pepper.jpg"), StepItem(id: 12118, name: "coconut milk", image: "coconut-milk.png"), StepItem(id: 19334, name: "brown sugar", image: "dark-brown-sugar.png"), StepItem(id: 6179, name: "fish sauce", image: "asian-fish-sauce.jpg"), StepItem(id: 14084, name: "wine", image: "red-wine.jpg")], equipment: [StepItem(id: 404645, name: "frying pan", image: "pan.png")]), Step(number: 5, step: "Simmer, uncovered, until sauce thickens slightly and chicken is completely cooked through, about 5 minutes.", ingredients: [StepItem(id: 0, name: "chicken", image: "whole-chicken-jpg"), StepItem(id: 0, name: "sauce", image: "")], equipment: []), Step(number: 6, step: "Stir in the Thai basil leaves, then spoon into a serving bowl.", ingredients: [StepItem(id: 2044, name: "fresh basil", image: "fresh-basil.jpg")], equipment: [StepItem(id: 404783, name: "bowl", image: "bowl.jpg")]), Step(number: 7, step: "Garnish with red chilies if desired and serve with jasmine rice.", ingredients: [StepItem(id: 10120444, name: "jasmine rice", image: "rice-jasmine-cooked.jpg"), StepItem(id: 10511819, name: "red chili pepper", image: "red-chili.jpg")], equipment: [])])], totalRatings: 538, averageRating: 4.714, views: 1804)
        
        static let recipeError = RecipeError(error: "You are not authorized. Please read https://spoonacular.com/food-api/docs#Authentication")
        static let tokenError = RecipeError(error: "Invalid Firebase token provided: Error: Decoding Firebase ID token failed. Make sure you passed the entire string JWT which represents an ID token. See https://firebase.google.com/docs/auth/admin/verify-id-tokens for details on how to retrieve an ID token.")
        
        static let terms = [Term(_id: "659355351c9a1fbc3bce6618", word: "produce", definition: "food grown by farming"), Term(_id: "6593556d1c9a1fbc3bce6619", word: "mince", definition: "cut up into small pieces"), Term(_id: "659355831c9a1fbc3bce661a", word: "broil", definition: "cook, such as in an oven"), Term(_id: "659355951c9a1fbc3bce661b", word: "simmer", definition: "stay below the boiling point when heated, such as with water"), Term(_id: "659355a41c9a1fbc3bce661c", word: "al dente", definition: "(\"to the tooth\") pasta or rice that's cooked so it can be chewed")]
        
        static let chef = Chef(uid: "oJG5PZ8KIIfvQMDsQzOwDbu2m6O2", email: "test@email.com", emailVerified: true, ratings: ["641024": 5, "663849": 3], recentRecipes: ["641024": "2024-10-17T02:54:07.471Z", "663849": "2024-10-17T22:28:27.387Z"], favoriteRecipes: ["641024"], token: "e30.e30.e30")
        static let authUrls = [AuthUrl(providerId: .google, authUrl: "https://www.google.com"), AuthUrl(providerId: .facebook, authUrl: "https://www.facebook.com"), AuthUrl(providerId: .github, authUrl: "https://github.com")]
    }
    
    struct Tabs {
        static let homeTitle = String(localized: "Home")
        static let searchTitle = String(localized: "Search")
        static let glossaryTitle = String(localized: "Glossary")
        static let profileTitle = String(localized: "Profile")
    }
    
    struct KeyboardNavigation {
        static let previous = String(localized: "Previous")
        static let next = String(localized: "Next")
        static let done = String(localized: "Done")
    }
    
    struct HomeView {
        static let findRecipeButton = String(localized: "Find Me a Recipe!")
        static let maxRecentRecipes = 10
        
        static let profileFavorites = String(localized: "💖 Favorites")
        static let profileRecentlyViewed = String(localized: "⌚ Recently Viewed")
        static let profileRatings = String(localized: "⭐ Ratings")
        static let signInForRecipes = String(localized: "Sign in to view your saved recipes")
    }
    
    struct RecipeView {
        static let recipeTitle = String(localized: "Recipe")
        static let noRecipe = String(localized: "No recipe loaded")
        static let favoriteAlt = String(localized: "Favorite this recipe")
        static let unFavoriteAlt = String(localized: "Un-favorite this recipe")
        static let shareAlt = String(localized: "Share this recipe")
        static let shareBody: @Sendable (String) -> String = { recipeName in
            String(localized: "Check out this low-effort recipe for \(recipeName)!")
        }
        static let shareUrl: @Sendable (Int) -> URL = { recipeId in
            URL(string: "\(recipeWebOrigin)/recipe/\(recipeId)")!
        }
        static let unknownRecipe = String(localized: "unknown recipe")
        
        static let recipeLinkAlt = String(localized: "Open recipe source")
        static let imageCopyright: @Sendable (String, String) -> LocalizedStringKey = { credit, source in
            // Convert to a LocalizedStringKey to parse the markdown
            LocalizedStringKey("Image © [\(credit)](\(source))")
        }
        static let recipeTime: @Sendable (Int) -> LocalizedStringKey = { minutes in
            // String(localized:) == NSLocalizedString
            LocalizedStringKey(String(localized: "**Time:** \(minutes) minute(s)"))
        }
        static let viewsAlt = String(localized: "views")
        
        static let starRatingNone = String(localized: "No ratings available")
        static let starRatingAverage: @Sendable (Double) -> String = { stars in
            String(localized: "Average rating: \(stars) out of 5 stars")
        }
        static let starRatingUser: @Sendable (Int) -> String = { stars in
            String(localized: "Your rating: \(stars) out of 5 stars")
        }
        static let starRatingInput: @Sendable (Int) -> String = { stars in
            String(localized: "Rate \(stars) star(s)")
        }
        static let totalRatings: @Sendable (Int) -> String = { rating in
            // Can't use a plural string since the raw rating value isn't in the string itself
            return if rating == 1 {
                String(localized: "\(rating.shorthand()) rating")
            } else {
                String(localized: "\(rating.shorthand()) ratings")
            }
        }
        static let ratingError = String(localized: "You must be signed in to rate this recipe")
        
        // String format specifiers: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
        static let mealTypes: @Sendable ([MealType]) -> LocalizedStringKey = { types in
            LocalizedStringKey(String(format: "**Great for:** %@", types.filter { $0 != .unknown }.map { $0.rawValue }.joined(separator: ", ")))
        }
        static let cuisines: @Sendable ([Cuisine]) -> LocalizedStringKey = { cultures in
            LocalizedStringKey(String(format: "**Cuisines:** %@", cultures.filter { $0 != .unknown }.map { $0.rawValue }.joined(separator: ", ")))
        }
        static let showRecipeButton = String(localized: "Show Me Another Recipe!")
        
        static let nutritionFacts = String(localized: "Nutrition Facts")
        static let healthScore: @Sendable (Int) -> String = { score in
            String(localized: "Health Score: \(score)%")
        }
        static let servings: @Sendable (Int) -> String = { servings in
            String(localized: "\(servings) serving(s)")
        }
        static let calories = String(localized: "Calories")
        static let fat = String(localized: "Fat")
        static let saturatedFat = String(localized: "Saturated Fat")
        static let carbohydrates = String(localized: "Carbohydrates")
        static let fiber = String(localized: "Fiber")
        static let sugar = String(localized: "Sugar")
        static let protein = String(localized: "Protein")
        static let cholesterol = String(localized: "Cholesterol")
        static let sodium = String(localized: "Sodium")
        
        static let summary = String(localized: "Summary")
        static let ingredients = String(localized: "Ingredients")
        static let ingredientUrl: @Sendable (String) -> URL? = { ingredient in
            URL(string: "https://img.spoonacular.com/ingredients_100x100/\(ingredient)")
        }
        static let steps = String(localized: "Steps")
        static let equipment = String(localized: "Equipment")
        static let equipmentUrl: @Sendable (String) -> URL? = { equipment in
            URL(string: "https://img.spoonacular.com/equipment_100x100/\(equipment)")
        }
        static let attribution = String(localized: "Powered by spoonacular")
    }
    
    struct SearchView {
        // Secondary view
        static let searchRecipes = String(localized: "Search for recipes by applying filters from the navigation menu.")
        
        // Filter form
        static let querySection = String(localized: "Query")
        static let queryPlaceholder = String(localized: "food")
        
        static let filterSection = String(localized: "Filters")
        static let minCals = 0
        static let maxCals = 2000
        static let calorieLabel = String(localized: "≤ Calories ≤")
        static let calorieUnit = String(localized: "kcal")
        static let calorieExceedMaxError = String(localized: "Error: Calories must be ≤ 2000")
        static let calorieInvalidRangeError = String(localized: "Error: Max calories cannot exceed min calories")
        
        static let vegetarianLabel = String(localized: "Vegetarian")
        static let veganLabel = String(localized: "Vegan")
        static let glutenFreeLabel = String(localized: "Gluten-Free")
        static let healthyLabel = String(localized: "Healthy")
        static let cheapLabel = String(localized: "Cheap")
        static let sustainableLabel = String(localized: "Sustainable")
        
        static let optionNone = String(localized: "(none)")
        static let ratingLabel = String(localized: "Rating")
        static let spiceLabel = String(localized: "Spice Level")
        static let typeLabel = String(localized: "Meal Type")
        static let cultureLabel = String(localized: "Cuisine")
        static let applyButton = String(localized: "Apply")
        
        // Results
        static let resultsTitle = String(localized: "Results")
        static let sortLabel = String(localized: "Sort")
        static let sortAltAsc = String(localized: "Sort in ascending order")
        static let sortAltDesc = String(localized: "Sort in descending order")
    }
    
    struct ProfileView {
        static let profileLoading = String(localized: "Getting your profile ready… 🧑‍🍳")
        static let profileHeader: @Sendable (String) -> String = { name in
            String(localized: "Chef \(name)")
        }
        static let favorites: @Sendable (Int) -> String = { recipes in
            String(localized: "\(recipes) favorite(s)")
        }
        static let recipesViewed: @Sendable (Int) -> String = { views in
            String(localized: "\(views) recipe(s) viewed")
        }
        static let loginMessage = String(localized: """
        Signing up for an account is free and gives you great perks, including:
        
        • Saving your favorite recipes
        • Saving more than 10 recently viewed recipes
        • Rating recipes
        • Syncing recipes across the web and mobile apps
        """)
        static let login = String(localized: "Login")
        static let logout = String(localized: "Logout")
        static let changeEmail = String(localized: "Change Email")
        static let changePassword = String(localized: "Change Password")
        static let deleteAccount = String(localized: "Delete Account")
        
        // Login form
        static let signInHeader = String(localized: "Sign In")
        static let signInSubHeader = String(localized: "Don't have an account?")
        static let usernameField = String(localized: "Username")
        static let passwordField = String(localized: "Password")
        static let passwordShow = String(localized: "Show password")
        static let passwordHide = String(localized: "Hide password")
        static let passwordForget = String(localized: "Forgot password?")
        static let oAuthHeader = String(localized: "Or sign in using:")
        static let signInSuccess = String(localized: "Signed in successfully!")
        static let signOutSuccess = String(localized: "Signed out successfully!")
        
        static let signUpHeader = String(localized: "Sign Up")
        static let signUpSubHeader = String(localized: "Already have an account?")
        static let emailField = String(localized: "Email")
        static let passwordConfirmField = String(localized: "Confirm Password")
        static let fieldRequired: @Sendable (String) -> String = { field in
            String(localized: "Error: \(field) is required")
        }
        static let emailInvalid = String(localized: "Error: Invalid email")
        static let passwordMinLengthInfo = String(localized: "Password must be at least 8 characters long")
        static let passwordMinLengthError = String(localized: "Error: Password must be at least 8 characters long")
        static let passwordMatch = String(localized: "Error: Passwords do not match")

        static let emailVerifyHeader = String(localized: "You're Almost There!")
        static let emailVerifyBody: @Sendable (String) -> LocalizedStringKey = { email in
            LocalizedStringKey(String(localized: """
        We just need to verify your email before you can put on the chef's hat.
        Check your email for a magic link sent to **\(email)**
        
        ⚠️ We will delete accounts from our system if they're not verified within 1 week.
        """))}
        static let emailVerifyRetryText = String(localized: "Didn't receive an email?")
        static let emailVerifyRetryLink = String(localized: "Resend")
        static let emailVerifySuccess = String(localized: "Email verified successfully!")
        static let forgetPasswordHeader = String(localized: "No problem! Enter your email so we can reset your password.")
        static let submitButton = String(localized: "Submit")
        static let forgetPasswordConfirm: @Sendable (String) -> LocalizedStringKey = { email in
            LocalizedStringKey(String(localized: """
        We sent an email to **\(email)**. Follow the instructions to reset your password.
        
        If you didn't receive an email, you may not have created an account with this email.
        """))}
        
        static let changeEmailField = String(localized: "New Email")
        static let changeEmailLoginAgain = String(localized: "This is a sensitive operation. Please sign in again.")
        static let changeEmailConfirm: @Sendable (String) -> LocalizedStringKey = { email in
            LocalizedStringKey(String(localized: "We sent an email to **\(email)**. Follow the instructions to change your email."))
        }
        static let changeEmailSuccess = String(localized: "Email updated successfully!")
        static let changePasswordField = String(localized: "New Password")
        static let changePasswordSuccess = String(localized: "Password updated successfully!")
        static let signInAgain = String(localized: "Please sign in again.")
        static let deleteAccountHeader = String(localized: "Are You Sure?")
        static let deleteAccountSubHeader = String(localized: """
        You will lose access to your favorite recipes.
        
        Enter your username to confirm.
        """)
        static let deleteAccountSuccess = String(localized: "Your account has been deleted.")
    }
}
