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
        let report = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                            location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
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
        let report = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                            location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
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
        // WHEN two perfectly identical reports
        let report = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                            location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        let reportMatches = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                                   location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        XCTAssert(report == reportMatches) // THEN == returns true
        
        // WHEN reports differ in ID ("id1" vs "id2")
        let reportDiffID = Report(id: "id2", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                                     location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        XCTAssertFalse(report == reportDiffID) // THEN == returns false
        
        // WHEN reports differ in Employee ("John" vs "Jan")
        let reportDiffEmployee = Report(id: "id1", employee: Employee(firstName: "Jan", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                                           location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        XCTAssertFalse(report == reportDiffEmployee) // THEN == returns false
        
        // WHEN reports differ in HealthPractice ("foobar" vs "barfoo")
        let reportDiffHealthPractice = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "barfoo"),
                                                 location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        XCTAssertFalse(report == reportDiffHealthPractice) // THEN == returns false
        
        // WHEN reports differ in Location ("facility1" vs "badFacility")
        let reportDiffLocation = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                                           location: Location(facilityName: "badFacility", unitNum: "1", roomNum: "2"), date: ModelsFactory.createMockDate())
        XCTAssertFalse(report == reportDiffLocation) // THEN == returns false
        
        // WHEN reports differ in Date
        let reportDiffDate = Report(id: "id1", employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "foobar"),
                                       location: Location(facilityName: "facility1", unitNum: "1", roomNum: "2"), date: Date())
        XCTAssertFalse(report == reportDiffDate) // THEN == returns false
    }
}
