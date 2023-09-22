//
//  MockReportDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockReportDataSource: ReportDataSource {
    var reportList: [Report] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]

    func getReportList() async -> Result<[Report], Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(reportList)
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            return .failure(error)
        }
        return .success(reportList.first)
    }
    
    func populateList() {
        reportList = DataFactory.makeReports()
    }
    func prepToThrow() {
        error = NSError()
    }
    func createNewReport(_ newReport: Report) async -> Result<Report?, Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            return .failure(error)
        }
        return .success(reportList.first ?? newReport)
    }
}
