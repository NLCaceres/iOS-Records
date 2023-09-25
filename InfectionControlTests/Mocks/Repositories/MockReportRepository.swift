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
    var calledCount: [String: Int] = [:]
    
    func populateList() {
        reportList = DataFactory.makeReports()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Report Repository!")
    }
    
    func getReportList() async throws -> [Report] {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList
    }
    
    func getReport(id: String) async throws -> Report? {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList.first
    }
    func createNewReport(_ newReport: Report) async throws -> Report? {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return reportList.first ?? newReport
    }
}
