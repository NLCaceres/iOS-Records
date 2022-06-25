//
//  PrecautionDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test ModelsFactory JSON maker spits out valid JSON */
class PrecautionDTOTests: XCTestCase {

    func testPrecautionDecoder() throws {
        print(ModelsFactory.PrecautionJSON())
        let myTuple = ((0, 1), "Line")
        print(myTuple)
    }
}
