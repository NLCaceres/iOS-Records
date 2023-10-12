//
//  MockEmployeeDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockEmployeeDataSource: EmployeeDataSource {
    var employeeList: [Employee] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func populateList() {
        employeeList = DataFactory.makeEmployees()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Employee Data Source")
    }
    
    func getEmployeeList() async -> Result<[Employee], Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(employeeList)
    }
    
    func getEmployee(id: String) async -> Result<Employee?, Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            return .failure(error)
        }
        return .success(employeeList.first)
    }
}
