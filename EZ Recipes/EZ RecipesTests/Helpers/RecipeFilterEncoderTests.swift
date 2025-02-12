//
//  RecipeFilterEncoderTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 2/17/24.
//

import XCTest
import Alamofire
@testable import EZ_Recipes

final class RecipeFilterEncoderTests: XCTestCase {
    let baseEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(
        arrayEncoding: .noBrackets,
        keyEncoding: .convertToKebabCase
    ))
    let url = URL(string: Constants.serverBaseUrl)!
    
    var encoder: RecipeFilterEncoder!
    var urlRequest: URLRequest!
    
    override func setUpWithError() throws {
        encoder = RecipeFilterEncoder(baseEncoder: baseEncoder)
        urlRequest = URLRequest(url: url)
    }
    
    func assertEquals(_ query1: String?, _ query2: String?) {
        // Split each query param and compare the sorted array
        let sortedQuery1 = query1?.split(separator: "&").sorted()
        let sortedQuery2 = query2?.split(separator: "&").sorted()
        
        XCTAssertEqual(sortedQuery1, sortedQuery2)
    }
    
    func testEncodeWithNoFilters() throws {
        // Given no recipe filters
        let parameters = RecipeFilter()
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then there shouldn't be any query parameters
        assertEquals(encodedRequest.url?.query(), "")
    }
    
    func testEncodeWithQuery() throws {
        // Given a recipe filter with a query
        let parameters = RecipeFilter(query: "fish")
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the query should appear in the query parameters
        assertEquals(encodedRequest.url?.query(), "query=fish")
    }
    
    func testEncodeWithComplexQuery() throws {
        // Given a query with special characters
        let parameters = RecipeFilter(query: "fish & chips")
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the query should be encoded in the query parameters
        assertEquals(encodedRequest.url?.query(), "query=fish%20%26%20chips")
    }
    
    func testEncodeWithCalorieRange() throws {
        // Given a recipe filter with a min & max calorie
        let parameters = RecipeFilter(minCals: 500, maxCals: 1000)
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the values should appear in the query parameters (with kebab casing)
        assertEquals(encodedRequest.url?.query(), "min-cals=500&max-cals=1000")
    }
    
    func testEncodeWithBools() throws {
        // Given a recipe filter with bool parameters
        let parameters = RecipeFilter(vegetarian: false, vegan: false, glutenFree: true, healthy: true, cheap: true, sustainable: false)
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the true keys should appear in the query parameters
        assertEquals(encodedRequest.url?.query(), "gluten-free&healthy&cheap")
    }
    
    func testEncodeWithSingleArrays() throws {
        // Given a recipe filter with one of each set
        let parameters = RecipeFilter(spiceLevel: [SpiceLevel.none.rawValue], type: [MealType.breakfast.rawValue], culture: [Cuisine.American.rawValue])
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the values should appear in the query parameters
        assertEquals(encodedRequest.url?.query(), "spice-level=none&type=breakfast&culture=American")
    }
    
    func testEncodeWithMultipleArrays() throws {
        // Given a recipe filter with multiple of each set
        let parameters = RecipeFilter(spiceLevel: [SpiceLevel.mild.rawValue, SpiceLevel.spicy.rawValue], type: [MealType.brunch.rawValue, MealType.lunch.rawValue, MealType.dinner.rawValue], culture: [Cuisine.Mexican.rawValue, Cuisine.Indian.rawValue, Cuisine.Thai.rawValue])
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then the values should appear in the query parameters with repeating keys
        assertEquals(encodedRequest.url?.query(), "spice-level=mild&spice-level=spicy&type=brunch&type=lunch&type=dinner&culture=Mexican&culture=Indian&culture=Thai")
    }
    
    func testEncodeWithAllParams() throws {
        // Given a recipe filter with every possible filter
        let parameters = RecipeFilter(query: "salad", minCals: 0, maxCals: 2000, vegetarian: true, vegan: true, glutenFree: true, healthy: true, cheap: true, sustainable: true, spiceLevel: [SpiceLevel.none.rawValue, SpiceLevel.mild.rawValue, SpiceLevel.spicy.rawValue], type: [MealType.horDOeuvre.rawValue], culture: [Cuisine.EasternEuropean.rawValue, Cuisine.MiddleEastern.rawValue])
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then all the values should appear in the query parameters
        assertEquals(encodedRequest.url?.query(), "query=salad&min-cals=0&max-cals=2000&vegetarian&vegan&gluten-free&healthy&cheap&sustainable&spice-level=none&spice-level=mild&spice-level=spicy&type=hor%20d%27oeuvre&culture=Eastern%20European&culture=Middle%20Eastern")
    }
    
    func testEncodeSpecialCharacters() throws {
        // Give a recipe filter with special characters
        let parameters = RecipeFilter(query: "pizza with :#[]@", token: "!$&'()*+,;=")
        
        // When encoded
        let encodedRequest = try encoder.encode(parameters, into: urlRequest)
        
        // Then all the characters should be URL-encoded
        assertEquals(encodedRequest.url?.query(), "query=pizza%20with%20%3A%23%5B%5D%40&token=%21%24%26%27%28%29%2A%2B%2C%3B%3D")
    }
}
