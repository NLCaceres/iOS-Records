//
//  EmployeeRepository.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* Repository should synthesize all data sources into single stream of data that can be delivered to the viewModel */
// In the case of iOS this is likely to be a temporary cache from CoreData followed by the higher priority API data
protocol EmployeeRepository {
    func getEmployeeList() async throws -> [Employee]
    func getEmployee(id: String) async throws -> Employee?
}

struct AppEmployeeRepository: EmployeeRepository {
    let employeeApiDataSource: EmployeeDataSource
    let employeeCoreDataSource: EmployeeDataSource
    
    init(employeeApiDataSource: EmployeeDataSource = EmployeeApiDataSource(),
         employeeCoreDataSource: EmployeeDataSource = EmployeeCoreDataSource()) {
        self.employeeApiDataSource = employeeApiDataSource
        self.employeeCoreDataSource = employeeCoreDataSource
    }
    
    func getEmployeeList() async throws -> [Employee] {
        let employeeApiResult = await employeeApiDataSource.getEmployeeList()
        
        switch employeeApiResult {
        case .success(let employeeList):
            return employeeList
        case .failure(let error):
            throw error // TODO: Maybe error case first checks CoreData to be sure no backup data?
        } // TODO: If no backup in CoreData then let this function altogether throw then viewModel renders the error
        
//        return [
//            Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Jill", surname: "Chambers"),
//            Employee(firstName: "Victor", surname: "Richards"), Employee(firstName: "Melody", surname: "Rios"),
//            Employee(firstName: "Brian", surname: "Ishida")
//        ]
    }
    func getEmployee(id: String) async throws -> Employee? {
        let employeeApiResult = await employeeApiDataSource.getEmployee(id: id)
        
        switch employeeApiResult {
        case .success(let employee):
            return employee
        case .failure(let error):
            throw error
        }
        
//        return Employee(firstName: "John", surname: "Smith")
    }
    
}
