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
        // Given a set of doubles (in the format (input, places, expectedOutput))
        let doubles = [
            (0, 0, "0"),
            (0, 2, "0"),
            (0.2, 0, "0"),
            (0.2500000, 2, "0.25"),
            (0.3000001, 1, "0.3"),
            (0.5, 0, "1"),
            (1.5, 0, "2"),
            (3.1415927, 3, "3.142"),
            (-53.24, 1, "-53.2"),
            (1029.529732, 0, "1,030"),
            (1029.529732, 4, "1,029.5297")
        ]
        
        // When calling .round
        // Then it should round the numbers to the specified number of places and remove trailing zeros
        for (input, places, expectedOutput) in doubles {
            XCTAssertEqual(input.round(to: places), expectedOutput, "\(input) rounded to \(input.round(to: places)) instead of \(expectedOutput)")
        }
    }
}
