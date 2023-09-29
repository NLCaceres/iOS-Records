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
        return try await getEntity { await employeeApiDataSource.getEmployeeList() }
//        return [ //? ID is important since it helps to be sure two employees are actually the same and don't just have the same name
//            Employee(id: "0", firstName: "John", surname: "Smith",
//                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
//            Employee(id: "1", firstName: "Jill", surname: "Chambers",
//                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
//            Employee(id: "2", firstName: "Victor", surname: "Richards",
//                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor")),
//            Employee(id: "3", firstName: "Melody", surname: "Rios",
//                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor")),
//            Employee(id: "4", firstName: "Brian", surname: "Ishida",
//                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor"))
//        ]
    }
    func getEmployee(id: String) async throws -> Employee? {
        return try await getEntity { await employeeApiDataSource.getEmployee(id: id) }
//        return Employee(firstName: "John", surname: "Smith")
    }
    
}
