//
//  ViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

// Ensure all ViewModels inject a repository to call the APIs
protocol ViewModel {
    associatedtype Repository
    init(repository: Repository)
}
