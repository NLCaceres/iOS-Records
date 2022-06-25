//
//  InfectionControlUITests.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Handles flow of UI from the starting tab view controller
Tests tab switching and popover from CreateReportCV to CreateReportVC */
class BaseUITests: XCTestCase {
    let app = XCUIApplication()
    var createReportCV: CreateReportCvRobot?
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launchArguments.append("-disableAnimations")
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        createReportCV = CreateReportCvRobot(app: self.app)
        guard createReportCV!.successfulLoad() else { XCTFail("Setup failed"); return }
    }

    override func tearDown() {
        createReportCV = nil
    }
    
    func testSwitchTabs() {
        // Start at CreateReportCV
        XCTAssert(createReportCV!.app.staticTexts["Create New Report"].exists)
        
        let profileView = createReportCV!.goToProfileView()
        // SHOULD now be at ProfileTab
        XCTAssert(profileView.app.staticTexts["Profile"].exists)
        
        let reportTableView = profileView.goToReportTableView()
        // SHOULD now be at ReportTableTab
        XCTAssert(reportTableView.app.staticTexts["Recent Reports"].waitForExistence(timeout: 10))
        // Moving from ReportTableView seems to cause no issue manually interacting with the app/simulator
        // BUT in this test, it stalls due to refreshControl not giving the animation OK
        // SOLUTION: launchArgs kill animations to speed things up
        let settingsView = reportTableView.goToSettingsView()
        // SHOULD now be at SettingsTab
        XCTAssert(settingsView.app.staticTexts["Settings"].exists)
    }
    
    func testExpectedCreateReportCollectionViewCounts() {
        XCTAssertEqual(createReportCV!.app.collectionViews.count, 1)
        // CollectionView exists. Check number of section headers
        XCTAssertEqual(createReportCV!.cvSectionHeaders.count, 2)
        // Count cells in the collectionView
        XCTAssertEqual(createReportCV!.allCells.count, 6)
        let label = createReportCV!.allCells.descendants(matching: .any).matching(NSPredicate(format: "label beginsWith 'Hand'")).firstMatch
        XCTAssert(label.exists)
        let otherLabel = createReportCV!.allCells.staticTexts["Airborne"]
        XCTAssert(otherLabel.exists)

    }

    func testNavigateToCreateReportView() {
        let createReportView = createReportCV!.goToCreateReportView()
        // After Tap, should be at createReport view, so check for expected views
        XCTAssert(createReportView.textField.exists)
        XCTAssert(createReportView.datePicker.exists)
        XCTAssert(createReportView.textField.exists)
        // Instead of children(matching: .pickerWheels), use .pickerWheels + subscript to specify the picker wheels expected val
        // It acts more like descendants() BUT benefit is concise + readable + returns an Element, not a Query
        XCTAssert(createReportView.normalPickers.pickerWheels["Hand Hygiene"].waitForExistence(timeout: 0.5))
        // The pickerWheel seemingly needs a bit to scroll to value after segue sets it
        XCTAssert(createReportView.normalPickers.pickerWheels["Facility Unit Room"].exists)
    }
    func testCreateReportViewCounts() {
        let createReportView = createReportCV!.goToCreateReportView()
        // After Tap, should be at createReport view
        XCTAssertEqual(createReportView.app.textFields.count, 1) // WHERE we have one textField
        let healthPracticeAndLocationPickers = app.pickers
        XCTAssertEqual(healthPracticeAndLocationPickers.count, 2) // AND two normal pickers
        let datePicker = app.datePickers
        XCTAssertEqual(datePicker.count, 1) // AND one datePicker
    }

}
