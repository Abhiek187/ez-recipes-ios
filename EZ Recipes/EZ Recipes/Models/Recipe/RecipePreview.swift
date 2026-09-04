//
//  RecipePreview.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 8/30/26.
//

import AppIntents

// Only expose fields that are shown on recipe cards
struct RecipePreview: AppEntity {
    // TODO: Migrate to @ComputedProperty when targeting iOS 26+
    @Property var id: Int
    @Property var name: String
    @Property var image: String
    @Property var time: Int
    @Property var summary: String
    @Property var calories: Double?
    @Property var totalRatings: Int?
    @Property var averageRating: Double?
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Recipe", numericFormat: LocalizedStringResource("\(placeholder: .int) recipes"))
    }
    
    var displayRepresentation: DisplayRepresentation {
        if let imageURL = URL(string: image) {
            DisplayRepresentation(title: "\(name)", subtitle: "\(summary)", image: DisplayRepresentation.Image(url: imageURL, width: 312, height: 231))
        } else {
            DisplayRepresentation(title: "\(name)", subtitle: "\(summary)")
        }
    }
    
    static let defaultQuery = RecipePreviewQuery()
    
    init(id: Int, name: String, image: String, time: Int, summary: String, calories: Double?, totalRatings: Int?, averageRating: Double?) {
        self.id = id
        self.name = name
        self.image = image
        self.time = time
        self.summary = summary
        self.calories = calories
        self.totalRatings = totalRatings
        self.averageRating = averageRating
    }
}

extension RecipePreview: URLRepresentableEntity {
    static var urlRepresentation: URLRepresentation {
        "https://ez-recipes-web.onrender.com/recipe/\(.id)" // matches a Universal Link to the recipe
    }
}

struct RecipePreviewQuery: EntityQuery {
    @Dependency
    var recipeRepository: NetworkManager
    
    func entities(for identifiers: [RecipePreview.ID]) async throws -> [RecipePreview] {
        var recipes: [RecipePreview] = []
        
        for recipeId in identifiers {
            let result = await recipeRepository.getRecipe(byId: recipeId)
            
            if case .success(let recipe) = result {
                recipes.append(recipe.toRecipePreview())
            }
        }
        
        return recipes
    }
}
