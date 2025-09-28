//
//  RecipeSortField.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 9/20/25.
//

enum RecipeSortField: String, Codable, CaseIterable {
    case calories, healthScore = "health-score", rating, views
    
    func label() -> String {
        return self.rawValue.replacingOccurrences(of: "-", with: " ").capitalized
    }
}
