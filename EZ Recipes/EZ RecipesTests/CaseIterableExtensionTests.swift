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
    
    func testIsFirst() {
        // Given enum values
        let testCases: [(Suit, Bool)] = [
            (.spade, true),
            (.heart, false),
            (.diamond, false),
            (.club, false)
        ]
        
        for (suit, expectedValue) in testCases {
            // When calling .isFirst
            let isFirst = suit.isFirst
            
            // Then it should return true for the enum with the smallest value
            XCTAssertEqual(isFirst, expectedValue, "Expected \(suit).isFirst to be \(expectedValue), but got \(isFirst)")
        }
    }
    
    func testIsLast() {
        // Given enum values
        let testCases: [(Suit, Bool)] = [
            (.spade, false),
            (.heart, false),
            (.diamond, false),
            (.club, true)
        ]
        
        for (suit, expectedValue) in testCases {
            // When calling .isLast
            let isLast = suit.isLast
            
            // Then it should return true for the enum with the largest value
            XCTAssertEqual(isLast, expectedValue, "Expected \(suit).isLast to be \(expectedValue), but got \(isLast)")
        }
    }
}
