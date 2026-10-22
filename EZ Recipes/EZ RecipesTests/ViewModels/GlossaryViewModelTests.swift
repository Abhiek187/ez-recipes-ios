//
//  GlossaryViewModelTests.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/16/26.
//

import Testing
@testable import EZ_Recipes

private extension GlossaryViewModel {
    convenience init(isSuccess: Bool = true) {
        var mockRepo = NetworkManagerMock.shared
        mockRepo.isSuccess = isSuccess
        
        self.init(repository: mockRepo)
    }
}

@MainActor
@Suite struct GlossaryViewModelTests {
    private let mockRepo = NetworkManagerMock.shared
    
    init() {
        // Start each test with a clean slate
        UserDefaultsManager.saveTerms(terms: [])
    }
    
    @Test func checkCachedTermsSuccess() async {
        // Given terms that aren't cached
        let viewModel = GlossaryViewModel()
        
        // When checking terms
        await viewModel.checkCachedTerms()
        
        // Then the terms should be saved
        #expect(viewModel.terms?.isEmpty == false)
    }
    
    @Test func checkCachedTermsFail() async {
        // Given terms that aren't cached
        let viewModel = GlossaryViewModel(isSuccess: false)
        
        // When checking terms and the API fails
        await viewModel.checkCachedTerms()
        
        // Then the terms shouldn't be saved
        #expect(viewModel.terms?.isEmpty == true)
    }
    
    @Test func checkCachedTermsExist() async {
        // Given terms that are cached
        UserDefaultsManager.saveTerms(terms: Constants.Mocks.terms)
        let viewModel = GlossaryViewModel()
        
        // When checking terms
        await viewModel.checkCachedTerms()
        
        // Then the terms should remain the same
        #expect(viewModel.terms?.count == Constants.Mocks.terms.count)
    }
}
