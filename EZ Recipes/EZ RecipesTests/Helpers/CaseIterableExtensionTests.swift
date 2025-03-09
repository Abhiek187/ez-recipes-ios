//
//  CaseIterableExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

import Testing
@testable import EZ_Recipes

@Suite struct CaseIterableExtensionTests {
    enum Suit: CaseIterable {
        case spade, heart, diamond, club
    }
    
    @Test("Get previous value", arguments: [
        // The first argument's types need to be explicit
        (Suit.spade, Suit.spade),
        (.heart, .spade),
        (.diamond, .heart),
        (.club, .diamond)
    ]) func testPrevious(suit: Suit, expectedSuit: Suit) {
        // Given enum values
        // When calling .previous()
        let previousSuit = suit.previous()
        
        // Then it should return the previous value (or the same if at the beginning)
        #expect(previousSuit == expectedSuit)
    }
    
    @Test("Get next value", arguments: [
        (Suit.spade, Suit.heart),
        (.heart, .diamond),
        (.diamond, .club),
        (.club, .club)
    ]) func testNext(suit: Suit, expectedSuit: Suit) {
        // Given enum values
        // When calling .next()
        let nextSuit = suit.next()
        
        // Then it should return the next value (or the same if at the end)
        #expect(nextSuit == expectedSuit)
    }
    
    @Test("Is first", arguments: [
        (Suit.spade, true),
        (.heart, false),
        (.diamond, false),
        (.club, false)
    ]) func testIsFirst(suit: Suit, expectedValue: Bool) {
        // Given enum values
        // When calling .isFirst
        let isFirst = suit.isFirst
        
        // Then it should return true for the enum with the smallest value
        #expect(isFirst == expectedValue)
    }
    
    @Test("Is last", arguments: [
        (Suit.spade, false),
        (.heart, false),
        (.diamond, false),
        (.club, true)
    ]) func testIsLast(suit: Suit, expectedValue: Bool) {
        // Given enum values
        // When calling .isLast
        let isLast = suit.isLast
        
        // Then it should return true for the enum with the largest value
        #expect(isLast == expectedValue)
    }
}
