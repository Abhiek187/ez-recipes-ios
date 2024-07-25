//
//  StringExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 7/24/24.
//

import XCTest
@testable import EZ_Recipes

final class StringExtensionTests: XCTestCase {
    func testConvertsSummariesToMarkdown() {
        let summaries = [
            (
                Constants.Mocks.blueberryYogurt.summary,
                "Need a **gluten free, lacto ovo vegetarian, and primal dessert**? Four-Ingredient Blueberry Frozen Yogurt could be an outstanding recipe to try. This recipe makes 2 servings with **162 calories**, **5g of protein**, and **1g of fat** each. For **$1.98 per serving**, this recipe **covers 9%** of your daily requirements of vitamins and minerals. Head to the store and pick up blueberries, non-fat greek yogurt, maple syrup, and a few other things to make it today. 1 person found this recipe to be delicious and satisfying. It is brought to you by Foodista. From preparation to the plate, this recipe takes approximately **approximately 45 minutes**. Overall, this recipe earns a **pretty good spoonacular score of 47%**. [Three-Ingredient Blueberry Mint Frozen Yogurt + 1 Year Reflection](https://spoonacular.com/recipes/three-ingredient-blueberry-mint-frozen-yogurt-+-1-year-reflection-606026), [Blueberry Frozen Yogurt](https://spoonacular.com/recipes/blueberry-frozen-yogurt-609219), and [Blueberry Frozen Yogurt](https://spoonacular.com/recipes/blueberry-frozen-yogurt-987795) are very similar to this recipe."
            ),
            (
                Constants.Mocks.chocolateCupcake.summary,
                "The recipe Gluten And Dairy Free Chocolate Cupcakes can be made **in approximately about 45 minutes**. One serving contains **919 calories**, **15g of protein**, and **52g of fat**. This gluten free and fodmap friendly recipe serves 4 and costs **$2.23 per serving**. It works well as a budget friendly dessert. Not a lot of people made this recipe, and 1 would say it hit the spot. Head to the store and pick up cocoa, xanthan gum, baking soda, and a few other things to make it today. This recipe is typical of American cuisine. It is brought to you by Foodista. Overall, this recipe earns a **rather bad spoonacular score of 23%**. Similar recipes are [Gluten Free Dairy Free Chocolate Zucchini Cupcakes](https://spoonacular.com/recipes/gluten-free-dairy-free-chocolate-zucchini-cupcakes-557465), [Grain-free, Gluten-free and Dairy-free Spiced Applesauce Cupcakes](https://spoonacular.com/recipes/grain-free-gluten-free-and-dairy-free-spiced-applesauce-cupcakes-615243), and [Gluten-Free Chocolate Cupcakes Made With Garbanzo Bean Flour – My Best Gluten-Free Cupcakes To Date](https://spoonacular.com/recipes/gluten-free-chocolate-cupcakes-made-with-garbanzo-bean-flour-my-best-gluten-free-cupcakes-to-date-518499)."
            ),
            (
                Constants.Mocks.thaiBasilChicken.summary,
                "Thai Basil Chicken With Green Curry might be just the main course you are searching for. This gluten free and dairy free recipe serves 4 and costs **$2.5 per serving**. One portion of this dish contains around **28g of protein**, **34g of fat**, and a total of **491 calories**. Only a few people made this recipe, and 1 would say it hit the spot. A mixture of chicken stock, fish sauce, curry paste, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes roughly **45 minutes**. It is an **affordable** recipe for fans of Indian food. It is brought to you by Foodista. Taking all factors into account, this recipe **earns a spoonacular score of 60%**, which is good. Users who liked this recipe also liked [Thai Basil Chicken With Green Curry](https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1522541), [Thai Basil Chicken With Green Curry](https://spoonacular.com/recipes/thai-basil-chicken-with-green-curry-1531093), and [Homemade Thai Green Curry Paste (And An Easy Thai Green Curry)](https://spoonacular.com/recipes/homemade-thai-green-curry-paste-and-an-easy-thai-green-curry-909057)."
            )
        ]
        
        for (input, expectedOutput) in summaries {
            XCTAssertEqual(input.htmlToMarkdown, expectedOutput)
        }
    }
    
    func testConvertsRegularHTMLToMarkdown() {
        let html = """
        <!-- Lorem ipsum generated HTML -->
        <div><p>Lorem ipsum dolor sit amet, <strong>consectetur adipiscing elit</strong>. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p><p><em>Duis aute irure dolor</em> in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<br><br><a href=\"https://example.com\">Visit our website</a> for more information.</p><div><p>Lorem ipsum <i>dolor sit amet</i>, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum. <b>Curabitur pulvinar</b> varius libero.</p><p><a href=\"https://example.com\">Click here</a> to learn more about our services.</p></div></div>
        <!-- end -->
        """
        let markdown = """
        
        
        Lorem ipsum dolor sit amet, **consectetur adipiscing elit**. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        *Duis aute irure dolor* in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        
        [Visit our website](https://example.com) for more information.
        
        Lorem ipsum *dolor sit amet*, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum. **Curabitur pulvinar** varius libero.
        [Click here](https://example.com) to learn more about our services.
        """
        
        XCTAssertEqual(html.htmlToMarkdown, markdown)
    }
}
