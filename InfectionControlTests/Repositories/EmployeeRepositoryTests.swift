//
//  EmployeeRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class EmployeeRepositoryTests: XCTestCase {
    func testGetEmployeeList() async throws {
        let mockDataSource = MockEmployeeDataSource()
        let employeeRepository = AppEmployeeRepository(employeeApiDataSource: mockDataSource)
        let employeeList = try! await employeeRepository.getEmployeeList()
        XCTAssertNotNil(employeeList)
        XCTAssertEqual(employeeList.count, 0) // List not populated so count still 0
        
        mockDataSource.populateList()
        let actualList = try! await employeeRepository.getEmployeeList()
        XCTAssertEqual(actualList.count, 5)
        XCTAssertEqual(actualList.first!.fullName, "John Smith")
        
        mockDataSource.prepToThrow()
        let nilEmployeeList = try? await employeeRepository.getEmployeeList()
        XCTAssertNil(nilEmployeeList) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getEmployeeList()"], 3)
    }
    func testGetEmployee() async throws {
        let mockDataSource = MockEmployeeDataSource()
        let employeeRepository = AppEmployeeRepository(employeeApiDataSource: mockDataSource)
        let employee = try? await employeeRepository.getEmployee(id: "1")
        XCTAssertNil(employee) // Gets nil Employee since list not populated!
        
        mockDataSource.populateList()
        let actualEmployee = try! await employeeRepository.getEmployee(id: "1")
        XCTAssertNotNil(actualEmployee)
        XCTAssertEqual(actualEmployee!.fullName, "John Smith")
        
        mockDataSource.prepToThrow()
        let nilEmployee = try? await employeeRepository.getEmployee(id: "1")
        XCTAssertNil(nilEmployee) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getEmployee(id:)"], 3)
    }
}
