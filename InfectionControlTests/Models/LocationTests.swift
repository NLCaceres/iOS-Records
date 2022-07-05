//
//  LocationTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class LocationTests: XCTestCase {
    
    func testDescription() throws {
        let location = Location(facilityName: "Foobar", unitNum: "1", roomNum: "2")
        XCTAssertEqual(location.description, "Location: Foobar Unit 1 Room 2")
        
        let bigLocation = Location(facilityName: "Some Long Name", unitNum: "1-2", roomNum: "2b")
        XCTAssertEqual(bigLocation.description, "Location: Some Long Name Unit 1-2 Room 2b")
    }

    func testEquality() throws {
        // WHEN perfectly identical
        let location = Location(facilityName: "Foobar", unitNum: "1", roomNum: "2")
        let matchingLocation = Location(facilityName: "Foobar", unitNum: "1", roomNum: "2")
        XCTAssert(location == matchingLocation) // THEN == returns true
        
        // WHEN differs on ID only (nil vs "id1")
        let locationWithId = Location(id: "id1", facilityName: "Foobar", unitNum: "1", roomNum: "2")
        XCTAssert(location == locationWithId)
        // WHEN identical on ID as well ("id1" vs "id1")
        let locationMatchingId = Location(id: "id1", facilityName: "Foobar", unitNum: "1", roomNum: "2")
        XCTAssert(locationWithId == locationMatchingId) // THEN == returns true
        // WHEN differs on ID ("id1" vs "id2")
        let locationDiffId = Location(id: "id2", facilityName: "Foobar", unitNum: "1", roomNum: "2")
        XCTAssert(locationWithId == locationDiffId) // THEN == STILL returns true
        
        // WHEN differs on unit num (1 vs 2)
        let locationDiffUnit = Location(facilityName: "Foobar", unitNum: "2", roomNum: "2")
        XCTAssertFalse(location == locationDiffUnit) // THEN == returns false
        
        // WHEN differs on room num (2 vs 4)
        let locationDiffRoom = Location(facilityName: "Foobar", unitNum: "1", roomNum: "4")
        XCTAssertFalse(location == locationDiffRoom) // THEN == returns false
        
        // WHEN differs on location name (Foobar vs Barfoo)
        let locationDiffFacility = Location(facilityName: "Barfoo", unitNum: "1", roomNum: "2")
        XCTAssertFalse(location == locationDiffFacility) // THEN == returns false
    }
}
