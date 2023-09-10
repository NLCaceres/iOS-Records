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
        reportList = MockReportDataSource.makeList()
    }
    func prepToThrow() {
        error = NSError()
    }
    
    static func makeList() -> [Report] {
        let employeeList = MockEmployeeDataSource.makeList()
        let healthPracticeList = MockHealthPracticeDataSource.makeList()
        let locationList = MockLocationDataSource.makeList()
        
        let Iso8601DateFormatter = ISO8601DateFormatter() // May 19 2019 6:36AM
        let exampleDate = Iso8601DateFormatter.date(from: "2019-05-19T06:36:05Z")!
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateList = [
            exampleDate,
            gregorianCalendar.date(byAdding: .day, value: 1, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: 7, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: -5, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: -27, to: exampleDate)!
        ]
        
        return [
            Report(employee: employeeList[0], healthPractice: healthPracticeList[0], location: locationList[1], date: dateList[0]),
            Report(employee: employeeList[1], healthPractice: healthPracticeList[4], location: locationList[3], date: dateList[1]),
            Report(employee: employeeList[2], healthPractice: healthPracticeList[3], location: locationList[2], date: dateList[2]),
            Report(employee: employeeList[3], healthPractice: healthPracticeList[0], location: locationList[4], date: dateList[3]),
            Report(employee: employeeList[4], healthPractice: healthPracticeList[1], location: locationList[0], date: dateList[4]),
        ]
    }
}
