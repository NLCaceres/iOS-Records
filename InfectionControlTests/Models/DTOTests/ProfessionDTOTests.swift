//
//  ProfessionDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test JsonFactory spits out valid JSON */
class ProfessionDTOTests: XCTestCase {

    func testProfessionDecoder() throws {
        // WHEN the Profession JSON has an ID
        let professionJSON = JsonFactory.ProfessionJSON(hasID: true)
        let firstID = JsonFactory.expectedProfessionID
        let professionData = professionJSON.data(using: .utf8)!
        let professionDTODecoded = professionData.toDTO(of: ProfessionDTO.self)! // Uses defaultDecoder() to convert Data into a DTO
        let profession = ProfessionDTO(id: "professionId\(firstID)", observedOccupation: "occupation\(firstID)", serviceDiscipline: "discipline\(firstID)")
        // THEN the default decoder will produce a professionDTO with a matching ID
        XCTAssertEqual(professionDTODecoded.id, profession.id)
        XCTAssertEqual(professionDTODecoded.observedOccupation, profession.observedOccupation)
        XCTAssertEqual(professionDTODecoded.serviceDiscipline, profession.serviceDiscipline)
    }
    
    func testProfessionEncoder() {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        // WHEN the default encoder receives a standard Profession
        let professionJSON = JsonFactory.ProfessionJSON(hasID: true)
        let firstID = JsonFactory.expectedProfessionID
        let profession = ProfessionDTO(id: "professionId\(firstID)", observedOccupation: "occupation\(firstID)", serviceDiscipline: "discipline\(firstID)")
        
        let professionEncoded = try! encoder.encode(profession)
        let professionEncodedStr = String(data: professionEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON
        XCTAssertEqual(professionJSON, professionEncodedStr)
    }
    
    func testCreateProfession() {
        // WHEN converting a DTO into its Base
        let professionDTO = ProfessionDTO(id: "professionId0", observedOccupation: "occupation0", serviceDiscipline: "discipline0")
        let profession = professionDTO.toBase()
        // THEN they will have matching property values
        XCTAssertEqual(profession.id, professionDTO.id)
        XCTAssertEqual(profession.observedOccupation, professionDTO.observedOccupation)
        XCTAssertEqual(profession.serviceDiscipline, professionDTO.serviceDiscipline)
    }
}
