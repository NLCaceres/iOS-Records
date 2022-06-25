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
        let shortAmericanStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "en")
        XCTAssertEqual(shortAmericanStyle, "10/1/20")
        let americanStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "en") // "MMM d, yyyy. h:mm a." == "Oct 1 2020, 3:12 PM."
        XCTAssertEqual(americanStyle, "Oct 1, 2020. 3:12 PM.")
        
        let shortEsStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "es")
        XCTAssertEqual(shortEsStyle, "1/10/20")
        let esStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "es") // "d MMM yyyy H:mm" == "1 Oct 2020. 15:12"
        XCTAssertEqual(esStyle, "1 oct 2020 15:12")
        
        let shortZhStyle = Report.dateHelper(ModelsFactory.createMockDate(), langCode: "zh")
        XCTAssertEqual(shortZhStyle, "1/10/20")
        let zhStyle = Report.dateHelper(ModelsFactory.createMockDate(), long: true, langCode: "zh") // "d MMM yyyy H:mm"
        XCTAssertEqual(zhStyle, "1 10月 2020 15:12")
    }
}
