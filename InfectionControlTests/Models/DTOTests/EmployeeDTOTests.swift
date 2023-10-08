//
//  EmployeeDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test JsonFactory spits out valid JSON */
class EmployeeDTOTests: XCTestCase {

    func testEmployeeDecoder() throws {
        // WHEN the Employee JSON has an ID
        let employeeJSON = JsonFactory.EmployeeJSON(hasID: true)
        let firstID = JsonFactory.expectedEmployeeID
        let employeeData = employeeJSON.data(using: .utf8)!
        let employeeDTODecoded = employeeData.toDTO(of: EmployeeDTO.self)! // Uses defaultDecoder() to convert Data into a DTO
        let employee = EmployeeDTO(id: "employeeId\(firstID)", firstName: "name\(firstID)", surname: "surname\(firstID)")
        // THEN the default decoder will produce an EmployeeDTO with a matching ID
        XCTAssertEqual(employeeDTODecoded.id, employee.id)
        XCTAssertEqual(employeeDTODecoded.firstName, employee.firstName)
        XCTAssertEqual(employeeDTODecoded.surname, employee.surname)
        
        // WHEN the EmployeeJSON has a Profession
        let employeeWithProfessionJSON = JsonFactory.EmployeeJSON(hasID: true, hasProfession: true)
        let secondID = JsonFactory.expectedEmployeeID
        let professionID = JsonFactory.expectedProfessionID
        let employeeWithProfessionData = employeeWithProfessionJSON.data(using: .utf8)!
        let employeeWithProfessionDTODecoded = employeeWithProfessionData.toDTO(of: EmployeeDTO.self)!
        let expectedProfession = ProfessionDTO(observedOccupation: "occupation\(professionID)", serviceDiscipline: "discipline\(professionID)")
        let employeeWithProfession = EmployeeDTO(id: "employeeId\(secondID)", firstName: "name\(secondID)",
                                                 surname: "surname\(secondID)", profession: expectedProfession)
        // THEN the default decoder will produce an EmployeeDTO with a Profession with its own matching properties
        XCTAssertEqual(employeeWithProfessionDTODecoded.id, employeeWithProfession.id)
        XCTAssertEqual(employeeWithProfessionDTODecoded.firstName, employeeWithProfession.firstName)
        XCTAssertEqual(employeeWithProfessionDTODecoded.surname, employeeWithProfession.surname)
        XCTAssertEqual(employeeWithProfessionDTODecoded.profession!.observedOccupation, employeeWithProfession.profession!.observedOccupation)
    }
    
    func testEmployeeEncoder() throws {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        // WHEN employee has no ID or Profession for encoding
        let expectedEmployeeJSON = JsonFactory.EmployeeJSON(hasID: false)
        let firstID = JsonFactory.expectedEmployeeID
        let employee = EmployeeDTO(firstName: "name\(firstID)", surname: "surname\(firstID)")
        let employeeEncoded = try! encoder.encode(employee)
        let employeeEncodedStr = String(data: employeeEncoded, encoding: .utf8)!
        // THEN matches expected JSON
        XCTAssertEqual(expectedEmployeeJSON, employeeEncodedStr)
        
        // WHEN Employee has ID for encoding
        let employeeWithIdJSON = JsonFactory.EmployeeJSON(hasID: true)
        let nextID = JsonFactory.expectedEmployeeID
        let employeeWithId = EmployeeDTO(id: "employeeId\(nextID)", firstName: "name\(nextID)", surname: "surname\(nextID)")
        let employeeWithIdEncoded = try! encoder.encode(employeeWithId)
        let employeeWithIdEncodedStr = String(data: employeeWithIdEncoded, encoding: .utf8)!
        // THEN matches expected JSON with a matching ID
        XCTAssertEqual(employeeWithIdJSON, employeeWithIdEncodedStr)
        
        // WHEN Employee has Profession for encoding
        let expectedEmployeeWithProfessionJSON = JsonFactory.EmployeeJSON(hasID: true, hasProfession: true)
        let finalID = JsonFactory.expectedEmployeeID
        let profID = JsonFactory.expectedProfessionID
        let newProfession = ProfessionDTO(observedOccupation: "occupation\(profID)", serviceDiscipline: "discipline\(profID)")
        let employeeWithProfession = EmployeeDTO(id: "employeeId\(finalID)", firstName: "name\(finalID)",
                                                 surname: "surname\(finalID)", profession: newProfession)
        let employeeWithProfessionEncoded = try! encoder.encode(employeeWithProfession)
        let employeeWithProfessionEncodedStr = String(data: employeeWithProfessionEncoded, encoding: .utf8)!
        // THEN matches expected JSON with a matching Profession object
        XCTAssertEqual(expectedEmployeeWithProfessionJSON, employeeWithProfessionEncodedStr)
    }
    
    func testCreateEmployee() throws {
        // WHEN EmployeeDTO w/out an ID
        let employeeDTO = EmployeeDTO(firstName: "name0", surname: "surname0", profession: nil)
        let employee = employeeDTO.toBase()
        // THEN its toBase() will return an Employee matching firstName and surname
        XCTAssertEqual(employee.id, employeeDTO.id)
        XCTAssertNil(employee.id)
        XCTAssertEqual(employee.firstName, employeeDTO.firstName)
        XCTAssertEqual(employee.surname, employeeDTO.surname)
        
        // WHEN EmployeeDTO with ID
        let nextEmployeeDTO = EmployeeDTO(id: "employeeId0", firstName: "name0", surname: "surname0", profession: nil)
        let nextEmployee = nextEmployeeDTO.toBase()
        // THEN its toBase() will return an Employee matching IDs
        XCTAssertEqual(nextEmployee.id, nextEmployeeDTO.id)
        XCTAssertNotNil(nextEmployee.id)
        
        // WHEN EmployeeDTO with a ProfessionDTO
        let profession = ProfessionDTO(id: "profesionId0", observedOccupation: "occupation0", serviceDiscipline: "discipline0")
        let finalEmployeeDTO = EmployeeDTO(id: "employeeId0", firstName: "name0", surname: "surname0", profession: profession)
        let finalEmployee = finalEmployeeDTO.toBase()
        // THEN its toBase() will return an Employee with a matching Profession with its own matching ID, occupation, and discipline
        XCTAssertEqual(finalEmployee.id, finalEmployeeDTO.id)
        XCTAssertEqual(finalEmployee.profession!.id, finalEmployeeDTO.profession!.id)
        XCTAssertEqual(finalEmployee.profession!.observedOccupation, finalEmployeeDTO.profession!.observedOccupation)
        XCTAssertEqual(finalEmployee.profession!.serviceDiscipline, finalEmployeeDTO.profession!.serviceDiscipline)
    }

}
