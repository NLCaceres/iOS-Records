//
//  MockReportRepository.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockReportRepository: ReportRepository {
    var reportList: [Report] = []
    var error: Error? = nil
    
    func populateList() {
        reportList = DataFactory.makeReports()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Report Repository!")
    }
    
    func getReportList() async throws -> [Report] {
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList
    }
    
    func getReport(id: String) async throws -> Report? {
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList.first
    }
    func createNewReport(_ newReport: Report) async throws -> Report? {
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList.first ?? newReport
    }
}
