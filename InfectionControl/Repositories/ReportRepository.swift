//
//  ReportRepository.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

protocol ReportRepository {
    func getReportList() async throws -> [Report]
    func getReport(id: String) async throws -> Report?
    func createNewReport(_ newReport: Report) async throws -> Report?
}

struct AppReportRepository: ReportRepository {
    let reportApiDataSource: ReportDataSource
    let reportCoreDataSource: ReportDataSource
    
    init(reportApiDataSource: ReportDataSource = ReportApiDataSource(),
         reportCoreDataSource: ReportDataSource = ReportCoreDataSource()) {
        self.reportApiDataSource = reportApiDataSource
        self.reportCoreDataSource = reportCoreDataSource
    }
    
    func getReportList() async throws -> [Report] {
        return try await getEntity { await reportApiDataSource.getReportList() }
//        return [
//            Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
//                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
//            Report(employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
//                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
//        ]
    }
    
    func getReport(id: String) async throws -> Report? {
        return try await getEntity { await reportApiDataSource.getReport(id: id) }
//        return Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
//                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
    }
    
    func createNewReport(_ newReport: Report) async throws -> Report? {
        return try await getEntity { await reportApiDataSource.createNewReport(newReport) }
    }
}
