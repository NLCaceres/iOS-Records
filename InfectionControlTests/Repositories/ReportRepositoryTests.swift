//
//  ReportRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class ReportRepositoryTests: XCTestCase {
    // Since the fetch portions of the repositories currently simply call getEntity + their apiDataSource, logic is fairly simple to test
    // by mocking the dataSources, asserting the returned entities match or errors are thrown as expected
    // Additionally to test whether they correctly call the expected dataSource functions, I can imitate "test spies" by adding
    // calledCount dictionaries that use function names as keys to the MockDataSources
    func testGetReportList() async throws {
        let mockDataSource = MockReportDataSource()
        let reportRepository = AppReportRepository(reportApiDataSource: mockDataSource)
        let reportList = try! await reportRepository.getReportList()
        XCTAssertNotNil(reportList)
        XCTAssertEqual(reportList.count, 0) // List not populated so 0 count
        
        mockDataSource.populateList()
        let actualList = try! await reportRepository.getReportList()
        XCTAssertEqual(actualList.count, 5)
        XCTAssertEqual(actualList.first!.employee.fullName, "John Smith")
        
        mockDataSource.prepToThrow()
        let nilReportList = try? await reportRepository.getReportList()
        XCTAssertNil(nilReportList) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getReportList()"], 3)
    }
    func testGetReport() async throws {
        let mockDataSource = MockReportDataSource()
        let reportRepository = AppReportRepository(reportApiDataSource: mockDataSource)
        let report = try? await reportRepository.getReport(id: "1")
        XCTAssertNil(report) // Gets nil Report since no populated list
        
        mockDataSource.populateList()
        let actualReport = try! await reportRepository.getReport(id: "1")
        XCTAssertNotNil(actualReport)
        XCTAssertEqual(actualReport!.employee.fullName, "John Smith")
        
        mockDataSource.prepToThrow()
        let nilReport = try? await reportRepository.getReport(id: "1")
        XCTAssertNil(nilReport) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getReport(id:)"], 3)
    }
}
