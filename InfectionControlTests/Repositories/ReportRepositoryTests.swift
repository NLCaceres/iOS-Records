//
//  ReportRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class ReportRepositoryTests: XCTestCase {
    // Since the fetch portions of the repositories currently simply call getResult + their apiDataSource,
    // there's not really much logic to test. Instead it's a bit more like testing whether they correctly call the expected
    // dataSource functions, which calls to mind "test spies" BUT there doesn't seem to be many good options out there
    // Without proper spies, it's likely best to just mock the data source and assert the expected returned entities or thrown errors
    // Unfortunately despite the underlying "getResult" generic doing the heavy lifting, and it having very simple tests,
    // The repository tests will just have to remain somewhat complex as a result of the setup and lack of spies
    func testGetReportList() async throws {
        let mockDataSource = MockReportDataSource(reportList: [
            Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
            Report(id: "Barfoo", employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        ])
        let reportRepository = AppReportRepository(reportApiDataSource: mockDataSource)
        let reportList = try! await reportRepository.getReportList()
        XCTAssertNotNil(reportList)
        XCTAssertEqual(reportList.count, 2)
        XCTAssertEqual(reportList.first?.id, "Foobar")
        
        let failingDataSource = MockReportDataSource(error: NSError())
        let failingRepository = AppReportRepository(reportApiDataSource: failingDataSource)
        let nilEmployeeList = try? await failingRepository.getReportList()
        XCTAssertNil(nilEmployeeList) // On fail, using "try?" causes thrown errors to return "nil"
    }
    func testGetReport() async throws {
        let mockDataSource = MockReportDataSource(
            report: Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                           location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        )
        let reportRepository = AppReportRepository(reportApiDataSource: mockDataSource)
        let report = try! await reportRepository.getReport(id: "1")
        XCTAssertNotNil(report)
        XCTAssertEqual(report!.id, "Foobar")
        
        let failingDataSource = MockReportDataSource(error: NSError())
        let failingRepository = AppReportRepository(reportApiDataSource: failingDataSource)
        let nilEmployeeList = try? await failingRepository.getReport(id: "1")
        XCTAssertNil(nilEmployeeList) // On fail, using "try?" causes thrown errors to return "nil"
    }
}
