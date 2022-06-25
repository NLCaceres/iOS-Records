//
//  SettingsViewUITests.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class SettingsViewUITests: XCTestCase {
    let app = XCUIApplication()
    var settingsView: SettingsViewRobot!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let createReportCV = try! commonAppSetup(app: app, args: ["-disableAnimations"])
        
        settingsView = createReportCV.goToSettingsView()
    }

    override func tearDownWithError() throws {
        settingsView = nil
    }
    
    func testDarkModeSwitch() {
        print(settingsView.app.cells.switches.debugDescription)
        XCTAssert(settingsView.app.cells.switches.count == 2) // The cell + its button both count so it becomes 2 instead of 1
        // TODO: Test that state changes. Observe backgroundColor?
    }
    
    func testColorWells() {
        // Interestingly .colorWells doesn't actually find the color picker button
        XCTAssert(settingsView.app.cells.images.matching(identifier: "UIColorWell").count == 3)
        // TODO: Test that colors of whole app change
    }
    
    func testPerformanceIndicatorSteppers() {
        XCTAssert(settingsView.app.cells.steppers.count == 2)
        // TODO: Go to profileView as supervisor and check if employees performance icons have changed
    }

    func testSettingsOptions() {
        let organizationSection = settingsView.app.tables.children(matching: .other).containing(.staticText, identifier: "Organization")
        // Cells exist side by side their section headers, so can use sections to verify their dynamic content should exist.
        XCTAssert(organizationSection.firstMatch.exists)
        XCTAssert(settingsView.app.tables.cells.matching(NSPredicate(format: "label contains 'Dark Mode'")).count == 1)
        // The cells containing colorWells can lose their label for some reason, so best to search based on colorWell presence
        XCTAssert(settingsView.app.tables.cells.containing(.image, identifier: "UIColorWell").count == 3)
        // The cells containing steppers also can lose their label, so search based on stepper presence
        XCTAssert(settingsView.app.tables.cells.containing(.stepper, identifier: nil).count == 2)
    }
}
