//
//  MockDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

// TODO: Convert these structs into classes
// TODO: Implement spies?
// TODO: Better utilize factories
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

struct MockReportDataSource: ReportDataSource {
    var reportList: [Report] = []
    var report: Report? = nil
    var error: Error? = nil
    
    init(report: Report? = nil, reportList: [Report] = [], error: Error? = nil) {
        self.report = report
        self.reportList = reportList
        self.error = error
    }
    
    
    func getReportList() async -> Result<[Report], Error> {
        if let error = error { return .failure(error) }
        return .success(reportList)
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        if let error = error { return .failure(error) }
        return .success(report)
    }
}
