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
        let report1 = Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                             location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        let report2 = Report(id: "Barfoo", employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                             location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        let reportDtoArray = [ReportDTO(from: report1), ReportDTO(from: report2)]
        mockNetworkManager.replacementData = reportDtoArray.toData() // Create data to let the networkManager fetch
        
        let reportListResult = await reportApiDataSource.getReportList() // Calls networkManager.fetch and parses the returned data
        let expectedList = [report1, report2]
        XCTAssertEqual(try! reportListResult.get(), expectedList) // Using the result.success() we can get the decoded array
        
        mockNetworkManager.error = NSError()
        let thrownResult = await reportApiDataSource.getReportList()
        let failedFetch = try? thrownResult.get() // Since it is a failure case, calling get() with "try?" returns nil
        XCTAssertNil(failedFetch)
    }
    func testGetReport() async throws {
        let mockReport = Report(id: "Foobar", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                                location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date())
        let reportDTO = ReportDTO(from: mockReport)
        let reportData = reportDTO.toData() // Create data to let the networkManager fetch
        mockNetworkManager.replacementData = reportData
        
        let reportResult = await reportApiDataSource.getReport(id: "foobar") // Calls the fetch and parses the returned report
        let actualReport = try! reportResult.get()!
        let dateString = actualReport.date.description
        let dateString2 = mockReport.date.description
        print("\(actualReport.date.description) vs \(mockReport.date.description)")
        print("\(dateString == dateString2)")
        // It's possible Swift's date ==() function is too accurate causing a floating-point precision sort of issue
        // Where date1 is "123456.123456" since 1970 and date2 after encoding/decoding is "123456.12345678" causing a slight difference and false equality
        XCTAssertEqual(actualReport, mockReport) // Using the result.success() we can get the decoded report
        
        mockNetworkManager.error = NSError()
        let thrownResult = await reportApiDataSource.getReport(id: "foobar")
        let failedFetch = try? thrownResult.get() // Since it is a failure case, calling get() with "try?" returns nil
        XCTAssertNil(failedFetch)
    }
}
