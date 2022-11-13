//
//  RecipeRepository.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

// A protocol allows mock repositories to be created for tests
protocol RecipeRepository {
    static var shared: Self { get } // singleton
    
    func getRandomRecipe() async -> Result<Recipe, Error>
    func getRecipe(byId id: String) async -> Result<Recipe, Error>
}
