//
//  EmployeeDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test that our Data Transfer Objects and their coding keys properly translate via Codable Protocol
   Also checks our normal Struct can be created from DTOs */
/* Bonus: Test ModelsFactory JSON maker spits out valid JSON */
class EmployeeDTOTests: XCTestCase {

    func testEmployeeDecoder() throws {
        
    }
    
    func testEmployeeEncoder() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        // When employee has no id or profession for encoding
        let expectedEmployeeJSON = ModelsFactory.EmployeeJSON(hasID: false)
        let firstID = ModelsFactory.expectedEmployeeID
        let employee = EmployeeDTO(firstName: "name\(firstID)", surname: "surname\(firstID)")
        let employeeEncoded = try! encoder.encode(employee)
        let employeeEncodedStr = String(data: employeeEncoded, encoding: .utf8)!
        // Then matches expectedJSON
        XCTAssertEqual(expectedEmployeeJSON, employeeEncodedStr)
        
        // When Employee has ID for encoding
        let employeeWithIdJSON = ModelsFactory.EmployeeJSON(hasID: true)
        let nextID = ModelsFactory.expectedEmployeeID
        let employeeWithId = EmployeeDTO(id: "employeeId\(nextID)", firstName: "name\(nextID)", surname: "surname\(nextID)")
        let employeeWithIdEncoded = try! encoder.encode(employeeWithId)
        let employeeWithIdEncodedStr = String(data: employeeWithIdEncoded, encoding: .utf8)!
        // Then matches expectedJSON
        XCTAssertEqual(employeeWithIdJSON, employeeWithIdEncodedStr)
        
        // When Employee has Profession for encoding
        let expectedEmployeeWithProfessionJSON = ModelsFactory.EmployeeJSON(hasID: true, hasProfession: true)
        let finalID = ModelsFactory.expectedEmployeeID
        let profID = ModelsFactory.expectedProfessionID
        let newProfession = ProfessionDTO(observedOccupation: "occupation\(profID)", serviceDiscipline: "discipline\(profID)")
        let employeeWithProfession = EmployeeDTO(id: "employeeId\(finalID)", firstName: "name\(finalID)",
                                                 surname: "surname\(finalID)", profession: newProfession)
        let employeeWithProfessionEncoded = try! encoder.encode(employeeWithProfession)
        let employeeWithProfessionEncodedStr = String(data: employeeWithProfessionEncoded, encoding: .utf8)!
        // Then matches expectedJSON
        XCTAssertEqual(expectedEmployeeWithProfessionJSON, employeeWithProfessionEncodedStr)
    }
    
    func testCreateEmployee() throws {
        // When EmployeeDTO used to Make Employee
        let employeeDTO = EmployeeDTO(id: "employeeId0", firstName: "name0", surname: "surname0", profession: nil)
        let employee = Employee(from: employeeDTO)
        //Then Matching firstName and surname
        XCTAssertEqual(employee.firstName, employeeDTO.firstName)
        XCTAssertEqual(employee.surname, employeeDTO.surname)
        
        // When EmployeeDTO with ID used to make Employee
        let nextEmployeeDTO = EmployeeDTO(id: "employeeId0", firstName: "name0", surname: "surname0", profession: nil)
        let nextEmployee = Employee(from: nextEmployeeDTO)
        // Then Matching IDs
        XCTAssertEqual(nextEmployee.id, nextEmployeeDTO.id)
        
        // When EmployeeDTO with Profession used to make Employee
        let profession = ProfessionDTO(id: "profesionId0", observedOccupation: "occupation0", serviceDiscipline: "discipline0")
        let finalEmployeeDTO = EmployeeDTO(id: "employeeId0", firstName: "name0", surname: "surname0", profession: profession)
        let finalEmployee = Employee(from: finalEmployeeDTO)
        // Then Matching IDs, occupation, and discipline from ProfessionDTO for Profession
        XCTAssertEqual(finalEmployee.id, finalEmployeeDTO.id)
        XCTAssertEqual(finalEmployee.profession?.id, finalEmployeeDTO.profession?.id)
        XCTAssertEqual(finalEmployee.profession?.observedOccupation, finalEmployeeDTO.profession?.observedOccupation)
        XCTAssertEqual(finalEmployee.profession?.serviceDiscipline, finalEmployeeDTO.profession?.serviceDiscipline)
    }

}
