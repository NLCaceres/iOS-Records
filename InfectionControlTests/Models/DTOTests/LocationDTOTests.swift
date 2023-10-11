//
//  LocationDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test JsonFactory spits out valid JSON */
class LocationDTOTests: XCTestCase {

    func testLocationDecoder() throws {
        // WHEN location JSON has an ID
        let locationJSON = JsonFactory.LocationJSON(hasID: true)
        let firstID = JsonFactory.expectedLocationID
        let locationData = locationJSON.data(using: .utf8)!
        let locationDecoded = locationData.toDTO(of: LocationDTO.self)! // Uses defaultDecoder() to convert Data into a DTO
        let location = LocationDTO(id: "locationId\(firstID)", facilityName: "facility\(firstID)", unitNum: "unit\(firstID)", roomNum: "room\(firstID)")
        // THEN the default decoder will produce a locationDTO with a matching ID
        XCTAssertEqual(locationDecoded.id, location.id)
        XCTAssertEqual(locationDecoded.facilityName, location.facilityName)
        XCTAssertEqual(locationDecoded.unitNum, location.unitNum)
        XCTAssertEqual(locationDecoded.roomNum, location.roomNum)
    }
    
    func testLocationEncoder() {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        // WHEN the default encoder receives a standard Location
        let locationJSON = JsonFactory.LocationJSON(hasID: true)
        let firstID = JsonFactory.expectedLocationID
        let location = LocationDTO(id: "locationId\(firstID)", facilityName: "facility\(firstID)", unitNum: "unit\(firstID)", roomNum: "room\(firstID)")
        
        let locationEncoded = try! encoder.encode(location)
        let locationEncodedStr = String(data: locationEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON
        XCTAssertEqual(locationJSON, locationEncodedStr)
    }
    
    func testCreateLocation() {
        // WHEN locationDTO with no ID
        let locationDTO = LocationDTO(id: nil, facilityName: "facility0", unitNum: "unit0", roomNum: "room0")
        let location = locationDTO.toBase()
        // THEN its toBase() will return a Location with a matching facilityName, unitNum, and roomNum, AS WELL AS nil ID
        XCTAssertNil(location.id)
        XCTAssertEqual(location.facilityName, locationDTO.facilityName)
        XCTAssertEqual(location.unitNum, locationDTO.unitNum)
        XCTAssertEqual(location.roomNum, locationDTO.roomNum)
        
        // WHEN locationDTO with an ID
        let nextLocationDTO = LocationDTO(id: "locationId0", facilityName: "facility0", unitNum: "unit0", roomNum: "room0")
        let nextLocation = nextLocationDTO.toBase()
        // THEN its toBase() will return a Location with matching ID
        XCTAssertNotNil(nextLocation.id)
        XCTAssertEqual(nextLocation.id, nextLocationDTO.id)
    }
}
