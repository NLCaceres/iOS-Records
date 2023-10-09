//
//  ReportDTOTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class ReportDTOTests: XCTestCase {
    func testReportDecoder() throws {
        // WHEN Report JSON has no ID
        let reportJSON = JsonFactory.ReportJSON()
        let reportData = reportJSON.data(using: .utf8)!
        let reportDecoded = reportData.toDTO(of: ReportDTO.self)
        let employeeID = JsonFactory.expectedEmployeeID
        let healthPracticeID = JsonFactory.expectedHealthPracticeID
        let locationID = JsonFactory.expectedLocationID
        let reportDTO = ReportDTO(employee: EmployeeDTO(firstName: "name\(employeeID)", surname: "surname\(employeeID)"),
                                  healthPractice: HealthPracticeDTO(name: "name\(healthPracticeID)"),
                                  location: LocationDTO(facilityName: "facility\(locationID)", unitNum: "unit\(locationID)", roomNum: "room\(locationID)"),
                                  date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        // THEN the default decoder will produce a reportDTO without an ID
        XCTAssertEqual(reportDecoded!.id, reportDTO.id)
        XCTAssertNil(reportDecoded!.id)
        XCTAssertEqual(reportDecoded!.employee!.firstName, reportDTO.employee!.firstName)
        XCTAssertEqual(reportDecoded!.healthPractice!.name, reportDTO.healthPractice!.name)
        XCTAssertEqual(reportDecoded!.location!.facilityName, reportDTO.location!.facilityName)
        XCTAssertEqual(reportDecoded!.date, reportDTO.date)
        
        // WHEN Report JSON has an ID
        let nextReportJSON = JsonFactory.ReportJSON(hasID: true)
        let reportID = JsonFactory.expectedReportID
        let nextEmployeeID = JsonFactory.expectedEmployeeID
        let nextHealthPracticeID = JsonFactory.expectedHealthPracticeID
        let nextLocationID = JsonFactory.expectedLocationID
        let nextReportData = nextReportJSON.data(using: .utf8)!
        let nextReportDecoded = nextReportData.toDTO(of: ReportDTO.self)!
        let nextExpectedReport = ReportDTO(id: "reportId\(reportID)",
                                           employee: EmployeeDTO(firstName: "name\(nextEmployeeID)", surname: "surname\(nextEmployeeID)"),
                                           healthPractice: HealthPracticeDTO(name: "name\(nextHealthPracticeID)"),
                                           location: LocationDTO(facilityName: "facility\(nextLocationID)",
                                                                 unitNum: "unit\(nextLocationID)", roomNum: "room\(nextLocationID)"),
                                           date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        // THEN the default decoder will produce a reportDTO with a matching ID
        XCTAssertEqual(nextReportDecoded.id, nextExpectedReport.id)
        XCTAssertEqual(nextReportDecoded.employee!.firstName, nextExpectedReport.employee!.firstName)
        XCTAssertEqual(nextReportDecoded.healthPractice!.name, nextExpectedReport.healthPractice!.name)
        XCTAssertEqual(nextReportDecoded.location!.facilityName, nextExpectedReport.location!.facilityName)
        XCTAssertEqual(nextReportDecoded.date, nextExpectedReport.date)
    }
    func testReportEncoder() throws {
        let encoder = defaultEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        // WHEN the default encoder receives a standard Report
        let reportJSON = JsonFactory.ReportJSON()
        let employeeID = JsonFactory.expectedEmployeeID
        let healthPracticeID = JsonFactory.expectedHealthPracticeID
        let locationID = JsonFactory.expectedLocationID
        let expectedReport = ReportDTO(employee: EmployeeDTO(firstName: "name\(employeeID)", surname: "surname\(employeeID)"),
                                       healthPractice: HealthPracticeDTO(name: "name\(healthPracticeID)"),
                                       location: LocationDTO(facilityName: "facility\(locationID)", unitNum: "unit\(locationID)", roomNum: "room\(locationID)"),
                                       date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        let reportEncoded = try! encoder.encode(expectedReport)
        let reportEncodedStr = String(data: reportEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON
        XCTAssertEqual(reportJSON, reportEncodedStr)
        
        // WHEN the default encoder receives a Report with an ID
        let nextReportJSON = JsonFactory.ReportJSON(hasID: true)
        let reportID = JsonFactory.expectedReportID
        let nextEmployeeID = JsonFactory.expectedEmployeeID
        let nextHealthPracticeID = JsonFactory.expectedHealthPracticeID
        let nextLocationID = JsonFactory.expectedLocationID
        let nextExpectedReport = ReportDTO(id: "reportId\(reportID)",
                                           employee: EmployeeDTO(firstName: "name\(nextEmployeeID)", surname: "surname\(nextEmployeeID)"),
                                           healthPractice: HealthPracticeDTO(name: "name\(nextHealthPracticeID)"),
                                           location: LocationDTO(facilityName: "facility\(nextLocationID)",
                                                                 unitNum: "unit\(nextLocationID)", roomNum: "room\(nextLocationID)"),
                                           date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        let nextReportEncoded = try! encoder.encode(nextExpectedReport)
        let nextReportEncodedStr = String(data: nextReportEncoded, encoding: .utf8)!
        // THEN the encoded JSON String will match our expected JSON with a matching ID
        XCTAssertEqual(nextReportJSON, nextReportEncodedStr)
    }
    func testCreateReport() throws {
        // WHEN reportDTO with no ID
        let reportDTO = ReportDTO(employee: EmployeeDTO(firstName: "name0", surname: "surname0"),
                                  healthPractice: HealthPracticeDTO(name: "name0"),
                                  location: LocationDTO(facilityName: "facility0", unitNum: "unit0", roomNum: "room0"),
                                  date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        let report = reportDTO.toBase()!
        // THEN its toBase() will return a Report with a nil ID and matching prop values
        XCTAssertEqual(report.id, reportDTO.id)
        XCTAssertNil(report.id)
        XCTAssertEqual(report.employee.firstName, reportDTO.employee!.firstName)
        XCTAssertEqual(report.healthPractice.name, reportDTO.healthPractice!.name)
        XCTAssertEqual(report.location.facilityName, reportDTO.location!.facilityName)
        XCTAssertEqual(report.date, reportDTO.date)
        
        // WHEN reportDTO with an ID
        let nextReportDTO = ReportDTO(id: "reportId1",
                                      employee: EmployeeDTO(firstName: "name1", surname: "surname1"),
                                      healthPractice: HealthPracticeDTO(name: "name1"),
                                      location: LocationDTO(facilityName: "facility1", unitNum: "unit1", roomNum: "room1"),
                                      date: ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!)
        let nextReport = nextReportDTO.toBase()!
        // THEN its toBase() will return a Report with matching ID that's not nil
        XCTAssertEqual(nextReport.id, nextReportDTO.id)
        XCTAssertNotNil(nextReport.id)
        XCTAssertEqual(nextReport.employee.firstName, nextReportDTO.employee!.firstName)
        XCTAssertEqual(nextReport.healthPractice.name, nextReportDTO.healthPractice!.name)
        XCTAssertEqual(nextReport.location.facilityName, nextReportDTO.location!.facilityName)
        XCTAssertEqual(nextReport.date, nextReportDTO.date)
    }
}
