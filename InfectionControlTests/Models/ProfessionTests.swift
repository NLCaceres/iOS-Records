//
//  ProfessionTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class ProfessionTests: XCTestCase {
    
    func testDescription() throws {
        let profession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssertEqual(profession.description, "Foobar Barfoo")
        
        let bigProfession = Profession(observedOccupation: "Some Long Name", serviceDiscipline: "And Another")
        XCTAssertEqual(bigProfession.description, "Some Long Name And Another")
    }

    func testEquality() throws {
        // WHEN two perfectly identical professions
        let profession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        let matchingProfession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssert(profession == matchingProfession) // THEN == returns true
        
        // WHEN differs on ID BUT occupation && discipline are identical (nil vs "id1")
        let professionWithId = Profession(id: "id1", observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssert(profession == professionWithId) // THEN == returns true
        // WHEN identical ID ("id1" vs "id1")
        let professionMatchingId = Profession(id: "id1", observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssert(professionWithId == professionMatchingId) // THEN == returns true
        // WHEN differs in ID only ("id1" vs "id2")
        let professionDiffId = Profession(id: "id2", observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssert(professionWithId == professionDiffId) // THEN == STILL returns true
        
        // WHEN differs on Occupation name
        let professionDiffOccupation = Profession(observedOccupation: "Foo", serviceDiscipline: "Barfoo")
        XCTAssertFalse(profession == professionDiffOccupation) // THEN == returns false
        
        // WHEN differs on Discipline name
        let professionDiffDiscipline = Profession(observedOccupation: "Foobar", serviceDiscipline: "Bar")
        XCTAssertFalse(profession == professionDiffDiscipline) // THEN == returns false
    }
}
