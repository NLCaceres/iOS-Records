//
//  EmployeeDataSource.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

protocol EmployeeDataSource {
    func getEmployeeList() async -> Result<[Employee], Error>
    func getEmployee(id: String) async -> Result<Employee?, Error>
}

/* For fetching from CoreData */
struct EmployeeCoreDataSource: EmployeeDataSource {
    func getEmployeeList() async -> Result<[Employee], Error> {
        print("Get the Employee List from CoreData")
        return .success([])
    }
    func getEmployee(id: String) async -> Result<Employee?, Error> {
        print("Get one Employee from CoreData")
        return .success(nil)
    }
}

/* Fetch from the API backend */
struct EmployeeApiDataSource: EmployeeDataSource {
    let networkManager: FetchingNetworkManager
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getEmployeeList() async -> Result<[Employee], Error> {
        return await getBaseArray(for: EmployeeDTO.self) { await networkManager.fetchTask(endpointPath: "/employees") }
    }
    func getEmployee(id: String) async -> Result<Employee?, Error> {
        return await getBase(for: EmployeeDTO.self) { await networkManager.fetchTask(endpointPath: "/employees/\(id)") }
    }
}
