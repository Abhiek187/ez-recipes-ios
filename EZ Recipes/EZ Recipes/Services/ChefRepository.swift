//
//  ChefRepository.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/25.
//

protocol ChefRepository: Sendable {
    static var shared: Self { get }
    
    func getChef(token: String) async -> Result<Chef, RecipeError>
    func createChef(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError>
    func updateChef(fields: ChefUpdate, token: String?) async -> Result<ChefEmailResponse, RecipeError>
    func deleteChef(token: String) async -> Result<Void, RecipeError> // empty response
    func verifyEmail(token: String) async -> Result<ChefEmailResponse, RecipeError>
    func login(credentials: LoginCredentials) async -> Result<LoginResponse, RecipeError>
    func logout(token: String) async -> Result<Void, RecipeError>
}
