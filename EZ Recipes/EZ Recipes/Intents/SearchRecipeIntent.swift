//
//  SearchRecipeIntent.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 8/25/26.
//

import AppIntents
import OSLog

// Domain: system, Schemas: search, open
// Test with Siri, Spotlight, & Shortcuts (may be buggy in the simulator)
// TODO: Test using AppIntentTesting on iOS 27+
@AppIntent(schema: .system.search) // use .system.searchInApp on iOS 27+
struct SearchRecipeIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    var criteria: StringSearchCriteria
    
    static let title: LocalizedStringResource = "Search Recipes"
    // Extra parameters control how the intent appears in Shortcuts
    static let description = IntentDescription("Search for recipes using various filters", searchKeywords: ["Search", "Recipes", "Easy", "EZ"], resultValueName: "Recipes")
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "SearchRecipeIntent")
    
    // criteria.term replaces the query parameter
//    @Parameter(title: "Query", description: "A full-text query to search recipes by name or description")
//    var query: String?
    // All other parameters must be optional if they're not part of the schema
    @Parameter(title: "Min Calories", description: "The minimum number of calories for a recipe", inclusiveRange: (0, 2000), requestValueDialog: IntentDialog("Min calories must be between 0 and 2000"))
    var minCals: Int?
    @Parameter(title: "Max Calories", description: "The maximum number of calories for a recipe", inclusiveRange: (0, 2000), requestValueDialog: IntentDialog("Max calories must be between 0 and 2000"))
    var maxCals: Int?
    @Parameter(title: "Vegetarian", description: "Whether the recipe must be vegetarian")
    var vegetarian: Bool?
    @Parameter(title: "Vegan", description: "Whether the recipe must be vegan")
    var vegan: Bool?
    @Parameter(title: "Gluten-Free", description: "Whether the recipe must be gluten-free")
    var glutenFree: Bool?
    @Parameter(title: "Healthy", description: "Whether the recipe must be healthy")
    var healthy: Bool?
    @Parameter(title: "Cheap", description: "Whether the recipe must be cheap")
    var cheap: Bool?
    @Parameter(title: "Sustainable", description: "Whether the recipe must be sustainable")
    var sustainable: Bool?
    @Parameter(title: "Rating", description: "The minimum number of stars a recipe is rated, from 1-5", inclusiveRange: (1, 5), requestValueDialog: IntentDialog("Rating must be between 1 and 5"))
    var rating: Int?
    @Parameter(title: "Spice Level", description: "The spice level for a recipe")
    var spiceLevel: Set<SpiceLevel>?
    @Parameter(title: "Meal Type", description: "The meal types a recipe is appropriate for, such as breakfast, lunch, or dinner")
    var type: Set<MealType>?
    @Parameter(title: "Cuisine", description: "The cuisine types associated with a recipe, such as American, Italian, or Latin American")
    var culture: Set<Cuisine>?
    
    private var paramsString: String {
        var params: [String] = []
        
        if !criteria.term.isEmpty { params.append("query=\(criteria.term)") }
        if let minCals { params.append("minCals=\(minCals)") }
        if let maxCals { params.append("maxCals=\(maxCals)") }
        if let vegetarian { params.append("vegetarian=\(vegetarian)") }
        if let vegan { params.append("vegan=\(vegan)") }
        if let glutenFree { params.append("glutenFree=\(glutenFree)") }
        if let healthy { params.append("healthy=\(healthy)") }
        if let cheap { params.append("cheap=\(cheap)") }
        if let sustainable { params.append("sustainable=\(sustainable)") }
        if let rating { params.append("rating=\(rating)") }
        if let spiceLevel { params.append("spiceLevel=\(spiceLevel)") }
        if let type { params.append("type=\(type)") }
        if let culture { params.append("culture=\(culture)") }
        
        return params.joined(separator: "\n")
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Search recipes using the provided filters")
    }
    
    @Dependency
    private var recipeRepository: NetworkManager
    
    func perform() async throws -> some IntentResult & ReturnsValue<[RecipePreview]> & ProvidesDialog {
        logger.debug("Calling App Intent \(#file) with args:\n\(paramsString)")
        
        // Validate all the filters provided
        if criteria.term.isEmpty && minCals == nil && maxCals == nil && vegetarian == nil && vegan == nil && glutenFree == nil && healthy == nil && cheap == nil && sustainable == nil && rating == nil && spiceLevel?.isEmpty != false && type?.isEmpty != false && culture?.isEmpty != false {
            throw IntentError.failure("At least one filter must be provided")
        }
        
        let recipeFilter = RecipeFilter(query: criteria.term, minCals: minCals, maxCals: maxCals, vegetarian: vegetarian ?? false, vegan: vegan ?? false, glutenFree: glutenFree ?? false, healthy: healthy ?? false, cheap: cheap ?? false, sustainable: sustainable ?? false, rating: rating, spiceLevel: Set(spiceLevel?.map(\.rawValue) ?? []), type: Set(type?.map(\.rawValue) ?? []), culture: Set(culture?.map(\.rawValue) ?? []))
        let result = await recipeRepository.getRecipes(withFilter: recipeFilter)
        
        switch result {
        case .success(let recipes):
            if recipes.isEmpty {
                throw IntentError.failure("No recipes found. Please try again with different filters.")
            }
            
            let recipePreview = recipes.map { $0.toRecipePreview() }
            // Have Siri list the top 5 recipes from the results to let them choose one
            let top5Recipes = recipePreview.prefix(5)
            let top5RecipesString = top5Recipes.map {
                var str = "\($0.name): \($0.time) minutes"
                if let calories = $0.calories { str += ", \(calories.round()) calories" }
                if let averageRating = $0.averageRating { str += ", \(averageRating.round(to: 2)) stars out of 5" }
                return str
            }.joined(separator: "; ")
            let dialog = IntentDialog(full: "Here \(top5Recipes.count == 1 ? "is" : "are") the top \(top5Recipes.count) \(top5Recipes.count == 1 ? "recipe" : "recipes") that match your criteria: \(top5RecipesString). Which one would you like to open?", supporting: "I found \(recipePreview.count) \(recipePreview.count == 1 ? "recipe" : "recipes") that match your criteria.")
            
            // Snippets must be < 400px tall
            return .result(value: recipePreview, dialog: dialog)
        case .failure(let recipeError):
            throw IntentError.failure(recipeError.error)
        }
    }
}
