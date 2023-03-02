//
//  MockDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

struct MockEmployeeDataSource: EmployeeDataSource {
    var employeeList: [Employee] = []
    var employee: Employee? = nil
    var error: Error? = nil
    
    init(employee: Employee? = nil, employeeList: [Employee] = [], error: Error? = nil) {
        self.employee = employee
        self.employeeList = employeeList
        self.error = error
    }
    
    
    func getEmployeeList() async -> Result<[Employee], Error> {
        if let error = error { return .failure(error) }
        return .success(employeeList)
    }
    
    func getEmployee(id: String) async -> Result<Employee?, Error> {
        if let error = error { return .failure(error) }
        return .success(employee)
    }
}
