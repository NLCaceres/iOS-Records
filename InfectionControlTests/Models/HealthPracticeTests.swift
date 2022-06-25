//
//  HealthPracticeTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class HealthPracticeTests: XCTestCase {

    func testEquality() throws {
        let healthPracticeOne = HealthPractice(name: "Foo")
        let healthPracticeTwo = HealthPractice(name: "Foo")
        XCTAssert(healthPracticeOne == healthPracticeTwo)
        
        let healthPracticeWithIdOne = HealthPractice(id: "id1", name: "Foo")
        let healthPracticeWithIdTwo = HealthPractice(id: "id1", name: "Foo")
        XCTAssert(healthPracticeWithIdOne == healthPracticeWithIdTwo)
    }
}
