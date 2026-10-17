//
//  GlossaryViewModel.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/16/26.
//

import OSLog

@MainActor
@Observable class GlossaryViewModel: ViewModel {
    var isLoading = false
    private(set) var terms = UserDefaultsManager.getTerms()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "GlossaryViewModel")
    private var repository: TermRepository
    
    required init(repository: TermRepository) {
        self.repository = repository
    }
    
    func checkCachedTerms() async {
        // Check if terms need to be cached
        if terms?.isEmpty == false { return }
        
        // The API can continue running in the background
        isLoading = true
        let result = await repository.getTerms()
        isLoading = false
        
        switch result {
        case .success(let terms):
            UserDefaultsManager.saveTerms(terms: terms)
            self.terms = terms
        case .failure(let recipeError):
            logger.warning("Failed to get terms :: error: \(recipeError.localizedDescription)")
        }
    }
}
