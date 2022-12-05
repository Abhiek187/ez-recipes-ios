//
//  DoubleExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 12/4/22.
//

import XCTest
@testable import EZ_Recipes

final class DoubleExtensionTests: XCTestCase {
    func testWhole() {
        // Given a set of doubles (in the format (input, expectedOutput))
        let doubles = [(0, "0"), (0.2, "0"), (0.5, "1"), (1.5, "2"), (53.24, "53"), (1029.529732, "1,030")]
        
        // When calling .whole
        // Then it should round the numbers to the nearest whole number and remove trailing zeros
        for (input, expectedOutput) in doubles {
            XCTAssertEqual(input.whole(), expectedOutput, "\(input) rounded to \(input.whole()) instead of \(expectedOutput)")
        }
    }
}
