//
//  IntExtensionTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 4/13/25.
//

import Testing
@testable import EZ_Recipes

@Suite struct IntExtensionTests {
    @Test("Compact numbers", arguments: [
        (0, "0"),
        (1, "1"),
        (999, "999"),
        (1000, "1K"),
        (1234, "1.2K"),
        (999999, "999.9K"),
        (1000000, "1M"),
        (1234567, "1.2M"),
        (999999999, "999.9M"),
        (1000000000, "1B"),
        (1234567890, "1.2B")
    ]) func shorthand(input: Int, expectedOutput: String) {
        // Given a set of ints
        // When calling .shorthand
        // Then it should create a compact string based on the size of the int
        #expect(input.shorthand() == expectedOutput)
    }
}
