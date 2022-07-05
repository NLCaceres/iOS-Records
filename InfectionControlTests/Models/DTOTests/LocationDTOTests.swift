//
//  LocationDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test ModelsFactory JSON maker spits out valid JSON */
class LocationDTOTests: XCTestCase {

    func testLocationDecoder() throws {
        let locationJSON = ModelsFactory.LocationJSON(hasID: true)
        let firstID = ModelsFactory.expectedLocationID
        let locationData = locationJSON.data(using: .utf8)!
        let locationDecoded = try! JSONDecoder().decode(LocationDTO.self, from: locationData)
        let location = LocationDTO(id: "locationId\(firstID)", facilityName: "facility\(firstID)", unitNum: "unit\(firstID)", roomNum: "room\(firstID)")
        XCTAssertEqual(locationDecoded.id, location.id)
        XCTAssertEqual(locationDecoded.facilityName, location.facilityName)
        XCTAssertEqual(locationDecoded.unitNum, location.unitNum)
        XCTAssertEqual(locationDecoded.roomNum, location.roomNum)
    }
    
    func testLocationEncoder() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let locationJSON = ModelsFactory.LocationJSON(hasID: true)
        let firstID = ModelsFactory.expectedLocationID
        let location = LocationDTO(id: "locationId\(firstID)", facilityName: "facility\(firstID)", unitNum: "unit\(firstID)", roomNum: "room\(firstID)")
        
        let locationEncoded = try! encoder.encode(location)
        let locationEncodedStr = String(data: locationEncoded, encoding: .utf8)!
        
        XCTAssertEqual(locationJSON, locationEncodedStr)
    }
    
    func testCreateLocation() {
        // When locationDTO with no ID makes Location
        let locationDTO = LocationDTO(id: nil, facilityName: "facility0", unitNum: "unit0", roomNum: "room0")
        let location = locationDTO.toBase()
        // Then Matching facilityName, unitNum, and roomNum, nil ID
        XCTAssertEqual(location.id, nil)
        XCTAssertEqual(location.facilityName, locationDTO.facilityName)
        XCTAssertEqual(location.unitNum, locationDTO.unitNum)
        XCTAssertEqual(location.roomNum, locationDTO.roomNum)
        
        // When locationDTO with an ID makes Location
        let nextLocationDTO = LocationDTO(id: "locationId0", facilityName: "facility0", unitNum: "unit0", roomNum: "room0")
        let nextLocation = nextLocationDTO.toBase()
        // Then ID is not nil and matching
        XCTAssertTrue(nextLocation.id != nil)
        XCTAssertEqual(nextLocation.id, nextLocationDTO.id)
    }
}
