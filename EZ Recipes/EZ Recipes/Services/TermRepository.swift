//
//  TermRepository.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/15/25.
//

protocol TermRepository: Sendable {
    static var shared: Self { get }
    
    func getTerms() async -> Result<[Term], RecipeError>
}
