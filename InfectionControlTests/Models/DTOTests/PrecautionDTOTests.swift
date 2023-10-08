//
//  PrecautionDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test JsonFactory spits out valid JSON */
class PrecautionDTOTests: XCTestCase {

    func testPrecautionDecoder() throws {
        // WHEN the Precaution JSON has an ID
        let precautionJSON = JsonFactory.PrecautionJSON(hasID: true)
        let firstID = JsonFactory.expectedPrecautionID
        let precautionData = precautionJSON.data(using: .utf8)!
        let precautionDTODecoded = precautionData.toDTO(of: PrecautionDTO.self)! // Uses defaultDecoder() to convert Data into a DTO
        let precaution = PrecautionDTO(id: "precautionId\(firstID)", name: "name\(firstID)")
        // THEN the default decoder will produce a PrecautionDTO with a matching ID
        XCTAssertEqual(precautionDTODecoded.id, precaution.id)
        XCTAssertEqual(precautionDTODecoded.name, precaution.name)
        
        // WHEN the Precaution JSON has an array of HealthPractices
        let precautionWithHealthPracticeJSON = JsonFactory.PrecautionJSON(hasID: true, numPractices: 1)
        let secondID = JsonFactory.expectedPrecautionID
        let healthPracticeID = JsonFactory.expectedHealthPracticeID
        let precautionWithHealthPracticeData = precautionWithHealthPracticeJSON.data(using: .utf8)!
        let precautionWithHealthPracticeDTODecoded = precautionWithHealthPracticeData.toDTO(of: PrecautionDTO.self)!
        // Don't actually need to link the healthPracticeArr to the precaution, since just asserting on it
        let healthPracticeArr = [HealthPracticeDTO(name: "name\(healthPracticeID)")]
        let precautionWithHealthPractice = PrecautionDTO(id: "precautionId\(secondID)", name: "name\(secondID)")
        // THEN the default decoder will produce an PrecautionDTO with a matching ID AND matching HealthPractice array
        XCTAssertEqual(precautionWithHealthPracticeDTODecoded.id, precautionWithHealthPractice.id)
        XCTAssertEqual(precautionWithHealthPracticeDTODecoded.name, precautionWithHealthPractice.name)
        XCTAssertEqual(precautionWithHealthPracticeDTODecoded.practices!.count, 1)
        XCTAssertEqual(precautionWithHealthPracticeDTODecoded.practices![0].id, healthPracticeArr[0].id)
    }
    
    func testPrecautionEncoder() throws {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        // WHEN Precaution has no ID or healthPractice for encoding
        let expectedPrecautionJSON = JsonFactory.PrecautionJSON(hasID: false)
        let firstID = JsonFactory.expectedPrecautionID
        let precaution = PrecautionDTO(name: "name\(firstID)")
        let precautionEncoded = try! encoder.encode(precaution)
        let precautionEncodedStr = String(data: precautionEncoded, encoding: .utf8)!
        // THEN matches expected JSON
        XCTAssertEqual(expectedPrecautionJSON, precautionEncodedStr)

        // WHEN Precaution has an ID
        let expectedPrecautionWithIdJSON = JsonFactory.PrecautionJSON(hasID: true)
        let secondID = JsonFactory.expectedPrecautionID
        let precautionWithID = PrecautionDTO(id: "precautionId\(secondID)", name: "name\(secondID)")
        let precautionWithIdEncoded = try! encoder.encode(precautionWithID)
        let precautionWithIdEncodedStr = String(data: precautionWithIdEncoded, encoding: .utf8)!
        // THEN matches expected JSON with matching ID
        XCTAssertEqual(expectedPrecautionWithIdJSON, precautionWithIdEncodedStr)
        
        // WHEN Precaution has a HealthPractice arr
        let expectedPrecautionWithHealthPracticeJSON = JsonFactory.PrecautionJSON(hasID: true, numPractices: 1)
        let thirdID = JsonFactory.expectedPrecautionID
        let healthPracticeID = JsonFactory.expectedHealthPracticeID
        let healthPracticeArr = [HealthPracticeDTO(name: "name\(healthPracticeID)")]
        let precautionWithHealthPractice = PrecautionDTO(id: "precautionId\(thirdID)", name: "name\(thirdID)", practices: healthPracticeArr)
        let precautionWithHealthPracticeEncoded = try! encoder.encode(precautionWithHealthPractice)
        let precautionWithHealthPracticeEncodedStr = String(data: precautionWithHealthPracticeEncoded, encoding: .utf8)!
        // THEN matches expected JSON with matching Health Practice arr
        XCTAssertEqual(expectedPrecautionWithHealthPracticeJSON, precautionWithHealthPracticeEncodedStr)
    }
    
    func testCreatePrecaution() throws {
        // WHEN Precaution w/out an ID
        let precautionDTO = PrecautionDTO(name: "name0")
        let precaution = precautionDTO.toBase()
        // THEN its toBase() will return a Precaution with matching name and nil ID
        XCTAssertEqual(precaution.id, precautionDTO.id)
        XCTAssertNil(precaution.id)
        XCTAssertEqual(precaution.name, precautionDTO.name)
        
        // WHEN Precaution w/ an ID
        let nextPrecautionDTO = PrecautionDTO(id: "precautionId0", name: "name0")
        let nextPrecaution = nextPrecautionDTO.toBase()
        // THEN its toBase() will return a Precaution with matching name and ID
        XCTAssertEqual(nextPrecaution.id, nextPrecautionDTO.id)
        XCTAssertNotNil(nextPrecaution.id)
        XCTAssertEqual(nextPrecaution.name, nextPrecautionDTO.name)
        
        // WHEN Precaution w/ an ID and a HealthPracticeArr
        let healthPracticeArr = [HealthPracticeDTO(id: "healthPracticeId0", name: "name0")]
        let finalPrecautionDTO = PrecautionDTO(id: "precautionId0", name: "name0", practices: healthPracticeArr)
        let finalPrecaution = finalPrecautionDTO.toBase()
        // THEN its toBase() will return a Precaution with a HealthPractice arr with its own matching name and ID
        XCTAssertEqual(finalPrecaution.id, finalPrecautionDTO.id)
        XCTAssertEqual(finalPrecaution.name, finalPrecautionDTO.name)
        XCTAssertEqual(finalPrecaution.practices!.count, 1)
        XCTAssertEqual(finalPrecaution.practices![0].id, healthPracticeArr[0].id)
    }
}
