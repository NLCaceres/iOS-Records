//
//  HealthPracticeTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class HealthPracticeTests: XCTestCase {

    func testEquality() throws {
        // WHEN perfectly identical
        let healthPractice = HealthPractice(name: "Foo")
        let matchingHealthPractice = HealthPractice(name: "Foo")
        XCTAssert(healthPractice == matchingHealthPractice) // THEN == returns true
        
        // WHEN differs on ID but same name (nil vs "id1")
        let healthPracticeWithId = HealthPractice(id: "id1", name: "Foo")
        XCTAssert(healthPractice == healthPracticeWithId) // THEN == returns true
        // WHEN perfectly identical with ID ("id1" vs "id1")
        let healthPracticeMatchingId = HealthPractice(id: "id1", name: "Foo")
        XCTAssert(healthPracticeWithId == healthPracticeMatchingId) // THEN == returns true
        // WHEN differs on ID ("id1" vs "id2)
        let healthPracticeDiffId = HealthPractice(id: "id2", name: "Foo")
        XCTAssert(healthPracticeWithId == healthPracticeDiffId) // THEN == STILL returns true
        
        // WHEN differs in name ("Foo" vs "Bar")
        let healthPracticeDiffName = HealthPractice(name: "Bar")
        XCTAssertFalse(healthPractice == healthPracticeDiffName) // THEN == returns false
        
        // WHEN Precaution matches
        let precaution = Precaution(name: "Bar")
        let healthPracticeWithPrecaution = HealthPractice(name: "Foo", precautionType: precaution)
        let healthPracticeMatchingPrecaution = HealthPractice(name: "Foo", precautionType: Precaution(name: "Bar"))
        XCTAssert(healthPracticeWithPrecaution == healthPracticeMatchingPrecaution) // THEN == returns true
        // WHEN precaution differs (nil vs Precaution())
        XCTAssertFalse(healthPractice == healthPracticeWithPrecaution)
        // WHEN precaution differs ("Bar" vs "Barf")
        let healthPracticeDiffPrecaution = HealthPractice(name: "Foo", precautionType: Precaution(name: "Barf"))
        XCTAssertFalse(healthPracticeWithPrecaution == healthPracticeDiffPrecaution)
    }
}
