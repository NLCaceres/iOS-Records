//
//  EmployeeTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class EmployeeTests: XCTestCase {
    
    func testDescription() throws {
        let employee = Employee(firstName: "John", surname: "Smith")
        XCTAssertEqual(employee.fullName, "John Smith")
        
        let bigEmployee = Employee(firstName: "John Kennedy", surname: "Smith-Cannes")
        XCTAssertEqual(bigEmployee.fullName, "John Kennedy Smith-Cannes")
    }

    func testEquality() throws {
        // WHEN perfectly identical
        let employee = Employee(firstName: "John", surname: "Smith")
        let matchingEmployee = Employee(firstName: "John", surname: "Smith")
        XCTAssert(employee == matchingEmployee) // THEN == returns true
        
        // WHEN differs in ID (nil vs "id1")
        let employeeWithId = Employee(id: "id1", firstName: "John", surname: "Smith")
        XCTAssert(employee == employeeWithId)
        // WHEN ID matches
        let employeeMatchingId = Employee(id: "id1", firstName: "John", surname: "Smith")
        XCTAssert(employeeWithId == employeeMatchingId) // THEN == returns true
        // WHEN id differs ("id1" vs "id2")
        let employeeDiffId = Employee(id: "id2", firstName: "John", surname: "Smith")
        XCTAssert(employeeWithId == employeeDiffId) // THEN == STILL returns true
        
        // WHEN differs in firstName ("John" vs "Jacob")
        let employeeDiffFirstName = Employee(firstName: "Jacob", surname: "Smith")
        XCTAssertFalse(employee == employeeDiffFirstName) // THEN == returns false
        
        // WHEN differs in surname ("Smith" vs "Cannes")
        let employeeDiffSurname = Employee(firstName: "John", surname: "Cannes")
        XCTAssertFalse(employee == employeeDiffSurname) // THEN == returns false
        
        // WHEN profession matches
        let profession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        let employeeWithProfession = Employee(firstName: "John", surname: "Smith", profession: profession)
        let matchingProfession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        let employeeMatchingProfession = Employee(firstName: "John", surname: "Smith", profession: matchingProfession)
        XCTAssert(employeeWithProfession == employeeMatchingProfession) // THEN == returns true
        // WHEN differs in profession (nil vs Profession())
        XCTAssertFalse(employee == employeeWithProfession) // THEN == returns false
        // WHEN differs in profession ("Foobar Barfoo" vs "Foo Barf")
        let diffProfession = Profession(observedOccupation: "Foo", serviceDiscipline: "Barf")
        let employeeDiffProfession = Employee(firstName: "John", surname: "Smith", profession: diffProfession)
        XCTAssertFalse(employeeWithProfession == employeeDiffProfession) // THEN == returns false
    }
}
