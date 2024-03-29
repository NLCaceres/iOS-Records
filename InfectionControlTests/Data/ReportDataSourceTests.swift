//
//  ReportDataSourceTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class ReportDataSourceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var reportApiDataSource: ReportApiDataSource!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        reportApiDataSource = ReportApiDataSource(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        reportApiDataSource = nil
    }
    
    func testGetReportList() async throws {
        let report1 = Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"),
                             healthPractice: HealthPractice(name: "Hand Hygiene"),
                             location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        let report2 = Report(id: "Barfoo", employee: Employee(firstName: "Melody", surname: "Rios"),
                             healthPractice: HealthPractice(name: "PPE"),
                             location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        let reportDtoArray = [ReportDTO(from: report1), ReportDTO(from: report2)]
        mockNetworkManager.replacementData = reportDtoArray.toData() // Create data to let the networkManager fetch
        
        let reportListResult = await reportApiDataSource.getReportList() // Calls networkManager.fetch and parses the returned data
        let expectedList = [report1, report2]
        XCTAssertEqual(try! reportListResult.get(), expectedList) // Using the result.success() we can get the decoded array
        
        mockNetworkManager.error = MockError.description("Error thrown while fetching Report List")
        let thrownResult = await reportApiDataSource.getReportList()
        let failedFetch = try? thrownResult.get() // Since it is a failure case, calling get() with "try?" returns nil
        XCTAssertNil(failedFetch)
    }
    func testGetReport() async throws {
        let mockReport = Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"),
                                healthPractice: HealthPractice(name: "Hand Hygiene"),
                                location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        let reportDTO = ReportDTO(from: mockReport)
        let reportData = reportDTO.toData() // Create data to let the networkManager fetch
        mockNetworkManager.replacementData = reportData
        
        let reportResult = await reportApiDataSource.getReport(id: "foobar") // Calls the fetch and parses the returned report
        let actualReport = try! reportResult.get()!
        XCTAssertEqual(actualReport, mockReport) // Using the result.success() we can get the decoded report
        
        mockNetworkManager.error = MockError.description("Error thrown while fetching a Report")
        let thrownResult = await reportApiDataSource.getReport(id: "foobar")
        let failedFetch = try? thrownResult.get() // Since it is a failure case, calling get() with "try?" returns nil
        XCTAssertNil(failedFetch)
    }
    func testCreateNewReport() async throws {
        let mockReport = Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"),
                                healthPractice: HealthPractice(name: "Hand Hygiene"),
                                location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        // MockNetworkManager.sendPostRequest has a fallback if replacementData isn't filled, since post requests commonly return the data sent anyway!
        let reportResult = await reportApiDataSource.createNewReport(mockReport)
        let reportCreated = try! reportResult.get()! // Report created should be returned back to indicate successful content creation
        XCTAssertEqual(reportCreated, mockReport)
        
        let reportDTO = ReportDTO(from: mockReport)
        let reportData = reportDTO.toData()
        mockNetworkManager.replacementData = reportData // EVEN if data is NOT originally filled in MockNetworkManager
        let filledMockReportResult = await reportApiDataSource.createNewReport(mockReport)
        let anotherReportCreated = try! filledMockReportResult.get()!
        XCTAssertEqual(anotherReportCreated, mockReport) // EXPECT Post Requests to get the same report back
        XCTAssertEqual(reportCreated, anotherReportCreated)
        
        mockNetworkManager.error = MockError.description("Error thrown while creating a Report")
        let thrownResult = await reportApiDataSource.createNewReport(mockReport)
        let failedCreation = try? thrownResult.get()
        XCTAssertNil(failedCreation)
    }
}
