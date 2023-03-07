//
//  EmployeeRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class EmployeeRepositoryTests: XCTestCase {
    func testGetEmployeeList() async throws {
        let mockDataSource = MockEmployeeDataSource(employeeList: [Employee(firstName: "John", surname: "Smith")])
        let employeeRepository = AppEmployeeRepository(employeeApiDataSource: mockDataSource)
        let employeeList = try! await employeeRepository.getEmployeeList()
        XCTAssertNotNil(employeeList)
        XCTAssertEqual(employeeList.count, 1)
        XCTAssertEqual(employeeList.first?.fullName, "John Smith")
        
        let failingDataSource = MockEmployeeDataSource(error: NSError())
        let failingRepository = AppEmployeeRepository(employeeApiDataSource: failingDataSource)
        let nilEmployeeList = try? await failingRepository.getEmployeeList()
        XCTAssertNil(nilEmployeeList) // On fail, using "try?" causes thrown errors to return "nil"
    }
    func testGetEmployee() async throws {
        let mockDataSource = MockEmployeeDataSource(employee: Employee(firstName: "John", surname: "Smith"))
        let employeeRepository = AppEmployeeRepository(employeeApiDataSource: mockDataSource)
        let employee = try! await employeeRepository.getEmployee(id: "1")
        XCTAssertNotNil(employee)
        XCTAssertEqual(employee!.fullName, "John Smith")
        
        let failingDataSource = MockEmployeeDataSource(error: NSError())
        let failingRepository = AppEmployeeRepository(employeeApiDataSource: failingDataSource)
        let nilEmployeeList = try? await failingRepository.getEmployee(id: "1")
        XCTAssertNil(nilEmployeeList) // On fail, using "try?" causes thrown errors to return "nil"
    }
}
