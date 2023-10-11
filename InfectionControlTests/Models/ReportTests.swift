//
//  ReportTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
    
class ReportTests: XCTestCase {
    override func setUp() { // As a fail-safe and to prevent test pollution
        Report.dateFormatter.locale = Locale(identifier: "en_US")
     }
    override func tearDown() {
        Report.dateFormatter.locale = Locale(identifier: "en_US")
    }
    // Any test can be annotated as throws & async. Use 'throws' to produce an unexpected failure when your test encounters an uncaught error.
    func testLocalDate() throws {
        var report = DataFactory.makeReports().first! // Starts as May 19 2019, but will change to "Oct 01, 2020, 03:12PM"
        report.date = DateComponents(calendar: Calendar(identifier: .gregorian),
                                     timeZone: TimeZone(abbreviation: "PST"), // Important to specify timezone or defaults to machine's timezone
                                     year: 2020, month: 10, day: 1, hour: 15, minute: 12).date!
        
        // WHEN using langCode with default langCode (expected to always be "en" or "en_US" even on CI/CD BUT possible for it to change)
        XCTAssertEqual(report.localDate, "10/1/20") // Defaults to short form with American style MM/dd/YYYY
        
        Report.dateFormatter.locale = Locale(identifier: "en") // WHEN using english langCode
        XCTAssertEqual(report.localDate, "10/1/20") // THEN mockdate == Month Day Year
        
        Report.dateFormatter.locale = Locale(identifier: "es") // WHEN using spanish langCode
        XCTAssertEqual(report.localDate, "1/10/20") // THEN mockdate == Day Month Year
        Report.dateFormatter.locale = Locale(identifier: "fr")
        XCTAssertEqual(report.localDate, "1/10/20")
        Report.dateFormatter.locale = Locale(identifier: "de")
        XCTAssertEqual(report.localDate, "1/10/20")
        Report.dateFormatter.locale = Locale(identifier: "it")
        XCTAssertEqual(report.localDate, "1/10/20")
        
        Report.dateFormatter.locale = Locale(identifier: "zh") // WHEN using chinese langCode
        XCTAssertEqual(report.localDate, "20/10/1") // THEN mockdate == Year/Month/Day
        Report.dateFormatter.locale = Locale(identifier: "ko")
        XCTAssertEqual(report.localDate, "20/10/1")
        Report.dateFormatter.locale = Locale(identifier: "ja")
        XCTAssertEqual(report.localDate, "20/10/1")

    }
    func testLocalDateTime() throws {
        var report = DataFactory.makeReports().first! // Should be May 19 2019 6:36AM, but will change to "Oct 01, 2020, 03:12PM"
        report.date = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "PST"),
                                     year: 2020, month: 10, day: 1, hour: 15, minute: 12).date!
        
        // WHEN using langCode with default langCode (expected to always be "en" or "en_US" even on CI/CD BUT possible for it to change)
        XCTAssertEqual(report.localDateTime, "Oct 1, 2020. 3:12 PM.") // Expected to default to American style
        
        Report.dateFormatter.locale = Locale(identifier: "en") // WHEN using english langCode
        XCTAssertEqual(report.localDateTime, "Oct 1, 2020. 3:12 PM.") // THEN mockdate == Month Day Year 12H:Mins
        
        Report.dateFormatter.locale = Locale(identifier: "es") // WHEN using spanish langCode
        XCTAssertEqual(report.localDateTime, "1 oct 2020 15:12") // THEN mockdate == Day Month Year 24H:Mins
        Report.dateFormatter.locale = Locale(identifier: "fr")
        XCTAssertEqual(report.localDateTime, "1 oct. 2020 15:12")
        Report.dateFormatter.locale = Locale(identifier: "de")
        XCTAssertEqual(report.localDateTime, "1 Okt. 2020 15:12")
        Report.dateFormatter.locale = Locale(identifier: "it")
        XCTAssertEqual(report.localDateTime, "1 ott 2020 15:12")
        
        Report.dateFormatter.locale = Locale(identifier: "zh") // WHEN using chinese langCode
        XCTAssertEqual(report.localDateTime, "2020 10月 1 15:12") // THEN mockdate == Year Month Day 24H:Mins
        Report.dateFormatter.locale = Locale(identifier: "ko")
        XCTAssertEqual(report.localDateTime, "2020 10월 1 15:12")
        Report.dateFormatter.locale = Locale(identifier: "ja")
        XCTAssertEqual(report.localDateTime, "2020 10月 1 15:12")
    }
    // Test Equality
    func testEquality() throws {
        let report = DataFactory.makeReports().first
        let expectedID = "0"
        let expectedEmployee = Employee(firstName: "John", surname: "Smith",
                                        profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse"))
        let expectedHealthPractice = HealthPractice(name: "Hand Hygiene", precautionType: Precaution(name: "Standard"))
        let expectedLocation = Location(facilityName: "USC", unitNum: "4", roomNum: "202")
        let expectedDate = ISO8601DateFormatter().date(from: "2019-05-19T06:36:05Z")!

        // WHEN two perfectly identical reports
        let reportMatches = Report(id: expectedID, employee: expectedEmployee, healthPractice: expectedHealthPractice,
                                   location: expectedLocation, date: expectedDate)
        XCTAssert(report == reportMatches) // THEN == returns true
        
        // WHEN reports differ in ID ("0" vs "1")
        let reportDiffID = Report(id: "1", employee: expectedEmployee, healthPractice: expectedHealthPractice,
                                  location: expectedLocation, date: expectedDate)
        XCTAssertFalse(report == reportDiffID) // THEN == returns false
        
        // WHEN reports differ in Employee ("John" vs "Jan")
        let reportDiffEmployee = Report(id: expectedID, employee: Employee(firstName: "Jan", surname: "Smith"),
                                        healthPractice: expectedHealthPractice, location: expectedLocation, date: expectedDate)
        XCTAssertFalse(report == reportDiffEmployee) // THEN == returns false
        let reportEmployeeMissingProfession = Report(id: expectedID, employee: Employee(firstName: "John", surname: "Smith"),
                                                     healthPractice: expectedHealthPractice, location: expectedLocation, date: expectedDate)
        XCTAssertFalse(report == reportEmployeeMissingProfession) // THEN == returns false BECAUSE Employee.Profession DOESN'T MATCH
        
        // WHEN reports differ in HealthPractice ("Hand Hygiene" vs "barfoo")
        let reportDiffHealthPractice = Report(id: expectedID, employee: expectedEmployee,
                                              healthPractice: HealthPractice(name: "barfoo"), location: expectedLocation, date: expectedDate)
        XCTAssertFalse(report == reportDiffHealthPractice) // THEN == returns false
        let reportHealthPracticeMissingPrecaution = Report(id: expectedID, employee: expectedEmployee,
                                                           healthPractice: HealthPractice(name: "Hand Hygiene"),
                                                           location: expectedLocation, date: expectedDate)
        XCTAssertFalse(report == reportHealthPracticeMissingPrecaution) // THEN == returns false BECAUSE HealthPractice.PrecautionType DOESN'T MATCH
        
        // WHEN reports differ in Location ("USC" vs "badFacility")
        let reportDiffLocation = Report(id: expectedID, employee: expectedEmployee, healthPractice: expectedHealthPractice,
                                        location: Location(facilityName: "badFacility", unitNum: "1", roomNum: "2"), date: expectedDate)
        XCTAssertFalse(report == reportDiffLocation) // THEN == returns false
        
        // WHEN reports differ in Date
        let reportDiffDate = Report(id: expectedID, employee: expectedEmployee,
                                    healthPractice: expectedHealthPractice, location: expectedLocation, date: Date())
        XCTAssertFalse(report == reportDiffDate) // THEN == returns false
    }
}
