//
//  HealthPracticeDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test JsonFactory spits out valid JSON */
// This particular DTO Test is a bit of overkill since it checks EVERY property individually in the
// 3 main tests, Decoder, Encoder and toBase implementation, ultimately making it a sanity check AND usage example
// The others can be and are comparatively straightforward
class HealthPracticeDTOTests: XCTestCase {

    func testHealthPracticeDecoder() throws {
        // WHEN healthPractice JSON has no ID key
        let healthPracticeJSON = JsonFactory.HealthPracticeJSON()
        let firstID = JsonFactory.expectedHealthPracticeID
        let healthPracticeData = healthPracticeJSON.data(using: .utf8)!
        let healthPracticeDecoded = healthPracticeData.toDTO(of: HealthPracticeDTO.self)! // Uses defaultDecoder() to convert Data into a DTO
        let healthPractice = HealthPracticeDTO(name: "name\(firstID)")
        // THEN name matches BUT ID is nil
        XCTAssertEqual(healthPracticeDecoded.id, nil)
        XCTAssertEqual(healthPracticeDecoded.id, healthPractice.id)
        XCTAssertEqual(healthPracticeDecoded.name, healthPractice.name)
        
        // WHEN healthPractice JSON has an ID key
        let healthPracticeWithIdJSON = JsonFactory.HealthPracticeJSON(hasID: true)
        let nextID = JsonFactory.expectedHealthPracticeID
        let healthPracticeWithIdData = healthPracticeWithIdJSON.data(using: .utf8)!
        let healthPracticeWithIdDecoded = healthPracticeWithIdData.toDTO(of: HealthPracticeDTO.self)!
        let healthPracticeWithId = HealthPracticeDTO(id: "healthPracticeId\(nextID)", name: "name\(nextID)")
        // THEN ID is filled and has a matching expected name
        XCTAssertEqual(healthPracticeWithIdDecoded.id, "healthPracticeId\(nextID)")
        XCTAssertEqual(healthPracticeWithIdDecoded.id, healthPracticeWithId.id)
        XCTAssertEqual(healthPracticeWithIdDecoded.name, healthPracticeWithId.name)
        
        // WHEN healthPractice JSON has a precaution key
        let healthPracticeWithPrecautionJSON = JsonFactory.HealthPracticeJSON(hasID: true, hasPrecaution: true)
        let finalID = JsonFactory.expectedHealthPracticeID
        let precautionID = JsonFactory.expectedPrecautionID
        let healthPracticeWithPrecautionData = healthPracticeWithPrecautionJSON.data(using: .utf8)!
        let healthPracticeWithPrecautionDecoded = healthPracticeWithPrecautionData.toDTO(of: HealthPracticeDTO.self)!
        let newPrecaution = PrecautionDTO(name: "precaution\(precautionID)")
        let healthPracticeWithPrecaution = HealthPracticeDTO(id: "healthPracticeId\(finalID)", name: "name\(finalID)", precautionType: newPrecaution)
        // THEN ID is filled and has a matching expected name and a properly coded precaution with its own matching ID
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.id, "healthPracticeId\(finalID)")
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.id, healthPracticeWithPrecaution.id)
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.name, healthPracticeWithPrecaution.name)
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.precautionType?.id, healthPracticeWithPrecaution.precautionType?.id)
    }
    
    func testHealthPracticeEncoder() {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        // WHEN the default encoder receives a standard HealthPractice w/out an ID
        let healthPracticeJSON = JsonFactory.HealthPracticeJSON(hasID: false)
        let firstID = JsonFactory.expectedHealthPracticeID
        let healthPractice = HealthPracticeDTO(name: "name\(firstID)", precautionType: nil)
        let healthPracticeEncoded = try! encoder.encode(healthPractice)
        let healthPracticeEncodedStr = String(data: healthPracticeEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON w/out an ID key-val
        XCTAssertEqual(healthPracticeJSON, healthPracticeEncodedStr)
        
        // WHEN the default encoder receives a standard HealthPractice w/ an ID
        let healthPracticeWithIdJSON = JsonFactory.HealthPracticeJSON(hasID: true)
        let nextID = JsonFactory.expectedHealthPracticeID
        let healthPracticeWithId = HealthPracticeDTO(id: "healthPracticeId\(nextID)", name: "name\(nextID)", precautionType: nil)
        let healthPracticeWithIdEncoded = try! encoder.encode(healthPracticeWithId)
        let healthPracticeWithIdEncodedStr = String(data: healthPracticeWithIdEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON WITH an ID key-val!
        XCTAssertEqual(healthPracticeWithIdJSON, healthPracticeWithIdEncodedStr)
        
        // WHEN the default encoder receives a standard HealthPractice w/ a Precaution
        let healthPracticeWithPrecautionJSON = JsonFactory.HealthPracticeJSON(hasID: true, hasPrecaution: true)
        let finalID = JsonFactory.expectedHealthPracticeID
        let precautionID = JsonFactory.expectedPrecautionID
        let newPrecaution = PrecautionDTO(name: "name\(precautionID)")
        let healthPracticeWithPrecaution = HealthPracticeDTO(id: "healthPracticeId\(finalID)", name: "name\(finalID)", precautionType: newPrecaution)
        let healthPracticeWithPrecautionEncoded = try! encoder.encode(healthPracticeWithPrecaution)
        let healthPracticeWithPrecautionEncodedStr = String(data: healthPracticeWithPrecautionEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON w/ all expected properties and values including a Precaution
        XCTAssertEqual(healthPracticeWithPrecautionJSON, healthPracticeWithPrecautionEncodedStr)
    }
    
    func testCreateHealthPractice() {
        // WHEN HealthPracticeDTO has NO ID
        let healthPracticeDTO = HealthPracticeDTO(id: nil, name: "name0", precautionType: nil)
        let healthPractice = healthPracticeDTO.toBase()
        // THEN its toBase() will return a HealthPractice with matching names only
        XCTAssertEqual(healthPractice.id, nil)
        XCTAssertEqual(healthPractice.name, healthPracticeDTO.name)
        
        // WHEN HealthPracticeDTO with ID
        let nextHealthPracticeDTO = HealthPracticeDTO(id: "healthPracticeId0", name: "name0", precautionType: nil)
        let nextHealthPractice = nextHealthPracticeDTO.toBase()
        // THEN its toBase() will return a HealthPractice with a matching ID as well
        XCTAssertEqual(nextHealthPractice.id, nextHealthPracticeDTO.id)
        XCTAssertEqual(nextHealthPractice.name, nextHealthPracticeDTO.name)
        
        // WHEN HealthPracticeDTO with Precaution
        let newPrecaution = PrecautionDTO(name: "name0")
        let finalHealthPracticeDTO = HealthPracticeDTO(id: "healthPracticeId0", name: "name0", precautionType: newPrecaution)
        let finalHealthPractice = finalHealthPracticeDTO.toBase()
        // THEN its toBase() will return a healthPractice with a matching Precaution as well!
        XCTAssertEqual(finalHealthPractice.id, finalHealthPracticeDTO.id)
        XCTAssertEqual(finalHealthPractice.precautionType?.id, finalHealthPracticeDTO.precautionType?.id)
        XCTAssertEqual(finalHealthPractice.precautionType?.name, finalHealthPracticeDTO.precautionType?.name)
    }
}
