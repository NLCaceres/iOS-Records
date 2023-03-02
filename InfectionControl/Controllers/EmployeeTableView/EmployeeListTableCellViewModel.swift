//
//  EmployeeListTableCellViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import Combine

class EmployeeListTableCellViewModel: ObservableObject {
    
    private let employee: Employee
    @Published var employeeFullName: String = ""
    @Published var employeeProfession: String = ""
    
    init(employee: Employee) {
        self.employee = employee
        
        employeeFullName = employee.fullName
        if let profession = employee.profession {
            employeeProfession = "\(profession.observedOccupation) \(profession.serviceDiscipline)"
        }
    }
}
