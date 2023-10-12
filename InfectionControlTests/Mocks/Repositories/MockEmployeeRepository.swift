//
//  MockEmployeeRepository.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockEmployeeRepository: EmployeeRepository {
    var employeeList: [Employee] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func populateList() {
        employeeList = DataFactory.makeEmployees()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Employee Repository")
    }
    
    func getEmployeeList() async throws -> [Employee] {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return employeeList
    }
    
    func getEmployee(id: String) async throws -> Employee? {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return employeeList.first
    }
}
