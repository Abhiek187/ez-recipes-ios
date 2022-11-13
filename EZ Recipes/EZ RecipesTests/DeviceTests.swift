//
//  DeviceTests.swift
//  EZ RecipesTests
//
//  Created by Abhishek Chaudhuri on 11/13/22.
//

import XCTest
@testable import EZ_Recipes

final class DeviceTests: XCTestCase {
    func testAllCases() {
        // Given the Device enum
        // When calling .all
        let allDevices = Device.all
        
        // Then it should return an array of all the devices' strings
        XCTAssertEqual(allDevices, ["iPhone 8", "iPhone 14 Pro Max", "iPad Pro (9.7-inch)"])
    }
}
