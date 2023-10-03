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
        let professionJSON = JsonFactory.ProfessionJSON(hasID: true)
        let firstID = JsonFactory.expectedProfessionID
        let professionData = professionJSON.data(using: .utf8)!
        let professionDecoded = try! JSONDecoder().decode(ProfessionDTO.self, from: professionData)
        let profession = ProfessionDTO(id: "professionId\(firstID)", observedOccupation: "occupation\(firstID)", serviceDiscipline: "discipline\(firstID)")
        XCTAssertEqual(professionDecoded.id, profession.id)
        XCTAssertEqual(professionDecoded.observedOccupation, profession.observedOccupation)
        XCTAssertEqual(professionDecoded.serviceDiscipline, profession.serviceDiscipline)
    }
    
    func testProfessionEncoder() {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let professionJSON = JsonFactory.ProfessionJSON(hasID: true)
        let firstID = JsonFactory.expectedProfessionID
        let profession = ProfessionDTO(id: "professionId\(firstID)", observedOccupation: "occupation\(firstID)", serviceDiscipline: "discipline\(firstID)")
        
        let professionEncoded = try! encoder.encode(profession)
        let professionEncodedStr = String(data: professionEncoded, encoding: .utf8)!
        
        XCTAssertEqual(professionJSON, professionEncodedStr)
    }
    
    func testCreateProfession() {
        let professionDTO = ProfessionDTO(id: "professionId0", observedOccupation: "occupation0", serviceDiscipline: "discipline0")
        let profession = professionDTO.toBase()
        XCTAssertEqual(profession.id, professionDTO.id)
        XCTAssertEqual(profession.observedOccupation, professionDTO.observedOccupation)
        XCTAssertEqual(profession.serviceDiscipline, professionDTO.serviceDiscipline)
    }
}
