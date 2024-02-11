//
//  CaseIterableExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

import XCTest
@testable import EZ_Recipes

final class CaseIterableExtensionTests: XCTestCase {
    enum Suit: CaseIterable {
        case spade, heart, diamond, club
    }
    
    func testPrevious() {
        // Given enum values
        let testCases: [(Suit, Suit)] = [
            (.spade, .spade),
            (.heart, .spade),
            (.diamond, .heart),
            (.club, .diamond)
        ]
        
        for (suit, expectedSuit) in testCases {
            // When calling .previous()
            let previousSuit = suit.previous()
            
            // Then it should return the previous value (or the same if at the beginning)
            XCTAssertEqual(previousSuit, expectedSuit, "Expected \(suit)'s previous value to be \(expectedSuit), but got \(previousSuit)")
        }
    }
    
    func testNext() {
        // Given enum values
        let testCases: [(Suit, Suit)] = [
            (.spade, .heart),
            (.heart, .diamond),
            (.diamond, .club),
            (.club, .club)
        ]
        
        for (suit, expectedSuit) in testCases {
            // When calling .next()
            let nextSuit = suit.next()
            
            // Then it should return the next value (or the same if at the end)
            XCTAssertEqual(nextSuit, expectedSuit, "Expected \(suit)'s next value to be \(expectedSuit), but got \(nextSuit)")
        }
    }
}
