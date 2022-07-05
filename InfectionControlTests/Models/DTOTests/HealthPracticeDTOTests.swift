//
//  HealthPracticeDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test ModelsFactory JSON maker spits out valid JSON */
class HealthPracticeDTOTests: XCTestCase {

    func testHealthPracticeDecoder() throws {
        // When healthPractice JSON has no ID key
        let healthPracticeJSON = ModelsFactory.HealthPracticeJSON()
        let firstID = ModelsFactory.expectedHealthPracticeID
        let healthPracticeData = healthPracticeJSON.data(using: .utf8)!
        let healthPracticeDecoded = try! JSONDecoder().decode(HealthPracticeDTO.self, from: healthPracticeData)
        let healthPractice = HealthPracticeDTO(name: "name\(firstID)")
        // Then
        XCTAssertEqual(healthPracticeDecoded.id, nil)
        XCTAssertEqual(healthPracticeDecoded.id, healthPractice.id)
        XCTAssertEqual(healthPracticeDecoded.name, healthPractice.name)
        
        // When healthPractice JSON has an ID Key
        let healthPracticeWithIdJSON = ModelsFactory.HealthPracticeJSON(hasID: true)
        let nextID = ModelsFactory.expectedHealthPracticeID
        let healthPracticeWithIdData = healthPracticeWithIdJSON.data(using: .utf8)!
        let healthPracticeWithIdDecoded = try! JSONDecoder().decode(HealthPracticeDTO.self, from: healthPracticeWithIdData)
        let healthPracticeWithId = HealthPracticeDTO(id: "healthPracticeId\(nextID)", name: "name\(nextID)")
        // Then
        XCTAssertEqual(healthPracticeWithIdDecoded.id, "healthPracticeId\(nextID)")
        XCTAssertEqual(healthPracticeWithIdDecoded.id, healthPracticeWithId.id)
        XCTAssertEqual(healthPracticeWithIdDecoded.name, healthPracticeWithId.name)
        
        // When healthPractice JSON has a precaution key
        let healthPracticeWithPrecautionJSON = ModelsFactory.HealthPracticeJSON(hasID: true, hasPrecaution: true)
        let finalID = ModelsFactory.expectedHealthPracticeID
        let precautionID = ModelsFactory.expectedPrecautionID
        let healthPracticeWithPrecautionData = healthPracticeWithPrecautionJSON.data(using: .utf8)!
        let healthPracticeWithPrecautionDecoded = try! JSONDecoder().decode(HealthPracticeDTO.self, from: healthPracticeWithPrecautionData)
        let newPrecaution = PrecautionDTO(name: "precaution\(precautionID)")
        let healthPracticeWithPrecaution = HealthPracticeDTO(id: "healthPracticeId\(finalID)", name: "name\(finalID)", precautionType: newPrecaution)
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.id, "healthPracticeId\(finalID)")
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.id, healthPracticeWithPrecaution.id)
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.name, healthPracticeWithPrecaution.name)
        XCTAssertEqual(healthPracticeWithPrecautionDecoded.precautionType?.id, healthPracticeWithPrecaution.precautionType?.id)
    }
    
    func testHealthPracticeEncoder() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let healthPracticeJSON = ModelsFactory.HealthPracticeJSON(hasID: false)
        let firstID = ModelsFactory.expectedHealthPracticeID
        let healthPractice = HealthPracticeDTO(name: "name\(firstID)", precautionType: nil)
        let healthPracticeEncoded = try! encoder.encode(healthPractice)
        let healthPracticeEncodedStr = String(data: healthPracticeEncoded, encoding: .utf8)!
        XCTAssertEqual(healthPracticeJSON, healthPracticeEncodedStr)
        
        let healthPracticeWithIdJSON = ModelsFactory.HealthPracticeJSON(hasID: true)
        let nextID = ModelsFactory.expectedHealthPracticeID
        let healthPracticeWithId = HealthPracticeDTO(id: "healthPracticeId\(nextID)", name: "name\(nextID)", precautionType: nil)
        let healthPracticeWithIdEncoded = try! encoder.encode(healthPracticeWithId)
        let healthPracticeWithIdEncodedStr = String(data: healthPracticeWithIdEncoded, encoding: .utf8)!
        XCTAssertEqual(healthPracticeWithIdJSON, healthPracticeWithIdEncodedStr)
        
        let healthPracticeWithPrecautionJSON = ModelsFactory.HealthPracticeJSON(hasID: true, hasPrecaution: true)
        let finalID = ModelsFactory.expectedHealthPracticeID
        let precautionID = ModelsFactory.expectedPrecautionID
        let newPrecaution = PrecautionDTO(name: "name\(precautionID)")
        let healthPracticeWithPrecaution = HealthPracticeDTO(id: "healthPracticeId\(finalID)", name: "name\(finalID)", precautionType: newPrecaution)
        let healthPracticeWithPrecautionEncoded = try! encoder.encode(healthPracticeWithPrecaution)
        let healthPracticeWithPrecautionEncodedStr = String(data: healthPracticeWithPrecautionEncoded, encoding: .utf8)!
        XCTAssertEqual(healthPracticeWithPrecautionJSON, healthPracticeWithPrecautionEncodedStr)
    }
    
    func testCreateHealthPractice() {
        // When HealthPracticeDTO has ID makes HealthPractice
        let healthPracticeDTO = HealthPracticeDTO(id: nil, name: "name0", precautionType: nil)
        let healthPractice = healthPracticeDTO.toBase()
        // Then Matching names
        XCTAssertEqual(healthPractice.name, healthPracticeDTO.name)
        
        // When HealthPracticeDTO with ID makes HealthPractice
        let nextHealthPracticeDTO = HealthPracticeDTO(id: "healthPracticeId0", name: "name0", precautionType: nil)
        let nextHealthPractice = nextHealthPracticeDTO.toBase()
        // Then Matching IDs
        XCTAssertEqual(nextHealthPractice.id, nextHealthPracticeDTO.id)
        
        // When HealthPracticeDTO with Precaution makes HealthPractice
        let newPrecaution = PrecautionDTO(name: "name0")
        let finalHealthPracticeDTO = HealthPracticeDTO(id: "healthPracticeId0", name: "name0", precautionType: newPrecaution)
        let finalHealthPractice = finalHealthPracticeDTO.toBase()
        // Then Precaution has matching ID and name
        XCTAssertEqual(finalHealthPractice.id, finalHealthPracticeDTO.id)
        XCTAssertEqual(finalHealthPractice.precautionType?.id, finalHealthPracticeDTO.precautionType?.id)
        XCTAssertEqual(finalHealthPractice.precautionType?.name, finalHealthPracticeDTO.precautionType?.name)
    }
}
