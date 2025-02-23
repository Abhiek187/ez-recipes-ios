//
//  RecipeRepository.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

// A protocol allows mock repositories to be created for tests
protocol RecipeRepository: Sendable {
    static var shared: Self { get } // singleton
    
    func getRecipes(withFilter filter: RecipeFilter) async -> Result<[Recipe], RecipeError>
    func getRandomRecipe() async -> Result<Recipe, RecipeError>
    func getRecipe(byId id: Int) async -> Result<Recipe, RecipeError>
    func getTerms() async -> Result<[Term], RecipeError>
}
