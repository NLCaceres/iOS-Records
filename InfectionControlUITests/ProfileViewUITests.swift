//
//  ProfileViewUITests.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class ProfileViewUITests: XCTestCase {
    let app = XCUIApplication()
    var profileView: ProfileViewRobot!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launchArguments.append("-disableAnimations")
        app.launch()
        
        let createReportCV = CreateReportCvRobot(app: self.app)
        guard createReportCV.successfulLoad() else { XCTFail("Setup failed"); return }
        
        profileView = createReportCV.goToProfileView()
    }

    override func tearDownWithError() throws {
        profileView = nil
    }
    
    func testEmployeeInfo() throws {
        XCTAssert(profileView.app.staticTexts["Missing employee name"].exists) // Starts as this
        XCTAssert(profileView.app.staticTexts["Profession info missing"].exists)
        XCTAssert(profileView.app.images["mask"].exists) // Default profile img
        
        // COULD use matching(identifier:) with the exact employee or occupation name BUT the predicate offers more flexibility via 'contains'
        // Following loads in once data task completes
        XCTAssert(profileView.app.staticTexts.matching(NSPredicate(format: "label contains 'Caceres'")).firstMatch.waitForExistence(timeout: 0.5))
        XCTAssert(profileView.app.staticTexts.matching(NSPredicate(format: "label contains 'Clinic'")).firstMatch.waitForExistence(timeout: 0.5))
    }

    func testLoadingIndicators() throws {
        XCTAssert(profileView.app.activityIndicators.count == 2)
        XCTAssert(profileView.app.activityIndicators["Loading your Employee Data"].exists)
        XCTAssert(profileView.app.activityIndicators["Loading Reports Data"].exists)
    }
    func testSegmentsAndLists() throws {
        XCTAssert(profileView.app.tables.count == 1)
        XCTAssert(profileView.app.tables.staticTexts["Recent Reports"].waitForExistence(timeout: 0.5))
        XCTAssert(profileView.app.tables.cells.count == 5)
        XCTAssert(!profileView.app.segmentedControls.firstMatch.exists)
        // Current default tests for normal employee
        // Future: Below should have tests for supervisors (segmentedControl exists + two tables can appear)
    }
}
