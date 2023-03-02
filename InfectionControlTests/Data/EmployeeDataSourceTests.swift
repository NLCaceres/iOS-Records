//
//  EmployeeDataSourceTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class EmployeeDataSourceTests: XCTestCase {
    var mockSession: MockURLSession!
    var mockNetworkManager: MockNetworkManager!
    var employeeApiDataSource: EmployeeApiDataSource!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        mockNetworkManager = MockNetworkManager(session: mockSession)
        employeeApiDataSource = EmployeeApiDataSource(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        mockSession = nil
        mockNetworkManager = nil
        employeeApiDataSource = nil
    }
    
    func testGetEmployeeList() async throws {
        let employeeDtoArray = [EmployeeDTO(from: Employee(firstName: "John", surname: "Smith")), EmployeeDTO(from: Employee(firstName: "Melody", surname: "Rios"))]
        let jsonEncoder = JSONEncoder()
        let employeeDtoArrayData = try? jsonEncoder.encode(employeeDtoArray)
        mockNetworkManager.replacementData = employeeDtoArrayData // Create data to let the networkManager fetch
        
        let employeeListResult = await employeeApiDataSource.getEmployeeList() // Calls networkManager.fetch and parses the returned data
        let expectedList = [Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Melody", surname: "Rios")]
        XCTAssertEqual(try! employeeListResult.get(), expectedList) // Using the result.success() we can get the decoded array
    }
    func testGetEmployee() async throws {
        let employeeDTO = EmployeeDTO(from: Employee(firstName: "John", surname: "Smith"))
        let employeeData = employeeDTO.toData() // Create data to let the networkManager fetch
        mockNetworkManager.replacementData = employeeData
        
        let employeeResult = await employeeApiDataSource.getEmployee(id: "foobar") // Calls the fetch and parses the returned employee
        let expectedEmployee = Employee(firstName: "John", surname: "Smith")
        XCTAssertEqual(try! employeeResult.get(), expectedEmployee) // Using the result.success() we can get the decoded employee
    }
}
