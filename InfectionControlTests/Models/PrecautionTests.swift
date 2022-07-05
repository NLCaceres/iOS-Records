//
//  PrecautionTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class PrecautionTests: XCTestCase {

    func testEquality() throws {
        // WHEN perfectly identical Precautions
        let precaution = Precaution(name: "Foo")
        let matchingPrecaution = Precaution(name: "Foo")
        XCTAssert(precaution == matchingPrecaution) // THEN == returns true
        
        // WHEN differs on ID but same name (nil vs "id1")
        let precautionWithId = Precaution(id: "id1", name: "Foo")
        XCTAssertFalse(precaution == precautionWithId) // THEN == returns false
        // WHEN identical on ID && name
        let precautionMatchingId = Precaution(id: "id1", name: "Foo")
        XCTAssert(precautionWithId == precautionMatchingId) // THEN == returns true
        // WHEN differs on ID ("id1" vs "id2")
        let precautionDiffId = Precaution(id: "id2", name: "Foo")
        XCTAssertFalse(precautionWithId == precautionDiffId) // THEN == returns false
        
        // WHEN differs in name ("Foo" vs "Bar")
        let precautionDiffName = Precaution(name: "Bar")
        XCTAssertFalse(precaution == precautionDiffName) // THEN == returns false
        
        // WHEN HealthPractices match
        let healthPractice = HealthPractice(name: "Foobar")
        let precautionWithHealthPractices = Precaution(name: "Foo", practices: [healthPractice])
        let matchingHealthPractice = HealthPractice(name: "Foobar")
        let precautionMatchingHealthPractices = Precaution(name: "Foo", practices: [matchingHealthPractice])
        XCTAssert(precautionWithHealthPractices == precautionMatchingHealthPractices) // THEN == returns true
        // WHEN healthPractices differs (nil vs [healthPractice])
        XCTAssertFalse(precaution == precautionWithHealthPractices) // THEN == returns false
        // WHEN healthPractices differ (["Foobar"] vs ["Barfoo"])
        let diffHealthPractice = HealthPractice(name: "Barfoo")
        let precautionWithDiffHealthPractices = Precaution(name: "Foo", practices: [diffHealthPractice])
        XCTAssertFalse(precautionWithHealthPractices == precautionWithDiffHealthPractices)
        // WHEN healthPractices differ (["Foobar"] vs ["Foobar", "Foobar"])
        let precautionWithMoreHealthPractices = Precaution(name: "Foo", practices: [healthPractice, healthPractice])
        XCTAssertFalse(precautionWithHealthPractices == precautionWithMoreHealthPractices) // THEN == returns false
    }

}
