//
//  ReportTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
    
class ReportTests: XCTestCase {
    // Any test can be annotated as throws & async. Use 'throws' to produce an unexpected failure when your test encounters an uncaught error.
    func testDateHelper() throws {
        // WHEN using english langCode with default short form
        let shortAmericanStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "en")
        XCTAssertEqual(shortAmericanStyle, "10/1/20") // THEN mockdate == "10/1/20"
        // WHEN using english langCode with longForm flag == true
        let americanStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "en") // "MMM d, yyyy. h:mm a." == "Oct 1 2020, 3:12 PM."
        XCTAssertEqual(americanStyle, "Oct 1, 2020. 3:12 PM.") // THEN mockdate == "Oct 1, 2020. 3:12 PM."
        
        
        // WHEN using spanish langCode with default short form
        let shortEsStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "es")
        XCTAssertEqual(shortEsStyle, "1/10/20") // THEN mockdate == "1/10/20"
        
        // WHEN using spanish langCode with longForm flag == true
        let esStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "es") // "d MMM yyyy H:mm" == "1 Oct 2020. 15:12"
        XCTAssertEqual(esStyle, "1 oct 2020 15:12") // THEN mockdate == "1 oct 2020 15:12"
        
        
        // WHEN using chinese langCode with default short form
        let shortZhStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "zh")
        XCTAssertEqual(shortZhStyle, "1/10/20") // THEN mockdate == "1/10/20"
        
        // WHEN using chinese langCode with longForm flag == true
        let zhStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "zh") // "d MMM yyyy H:mm"
        XCTAssertEqual(zhStyle, "1 10月 2020 15:12") // THEN mockdate == "1 10月 2020 15:12"
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
