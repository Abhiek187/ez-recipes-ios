//
//  ViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

// Ensure all ViewModels inject a repository to call the APIs
// All ViewModels will make changes to the UI
@MainActor
protocol ViewModel {
    associatedtype Repository
    init(repository: Repository)
}
