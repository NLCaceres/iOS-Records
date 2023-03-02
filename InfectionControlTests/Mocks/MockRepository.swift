//
//  MockRepository.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

struct MockEmployeeRepository: EmployeeRepository {
    var employeeList: [Employee] = []
    var employee: Employee? = nil
    
    init(employee: Employee? = nil, employeeList: [Employee] = []) {
        self.employee = employee
        self.employeeList = employeeList
    }
    
    func getEmployeeList() async throws -> [Employee] {
        return employeeList
    }
    
    func getEmployee(id: String) async throws -> Employee? {
        return employee
    }
}
