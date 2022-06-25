//
//  CreateReportVcUITests.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class CreateReportVcUITests: XCTestCase {
    let app = XCUIApplication()
    var createReportVC: CreateReportViewRobot?
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launchArguments.append("-disableAnimations")
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        let createReportCV = CreateReportCvRobot(app: self.app)
        guard createReportCV.successfulLoad() else { XCTFail("Setup failed"); return }
        createReportVC = createReportCV.goToCreateReportView()
    }

    override func tearDown() {
        createReportVC = nil
    }

    func testEmployeeSegue() throws {
        XCTAssert(createReportVC!.textField.exists)
        
        let seguedEmployeeTableView = createReportVC!.goToEmployeeTableView()
        let employeeNavTitle = createReportVC!.app.navigationBars["Employee List"]
        // Now in EmployeeTableView
        XCTAssert(employeeNavTitle.waitForExistence(timeout: 0.2)) // Need a moment to let segue finish
        XCTAssertEqual(seguedEmployeeTableView.employeeListNav.label, employeeNavTitle.label)
        
        XCTAssertFalse(seguedEmployeeTableView.selectButton.isEnabled) // Select Button notEnabled by default
        
        seguedEmployeeTableView.selectRow() // By default clicks physicianRow
        XCTAssert(seguedEmployeeTableView.physicianRow.isSelected)
        XCTAssert(seguedEmployeeTableView.selectButton.isEnabled) // Select button now ready
        
        let physicianRowName = seguedEmployeeTableView.physicianNameTextView.label // Same physician row containing this textview
        seguedEmployeeTableView.finalizeSelection()
        
        // WHEN segue unwinds, THEN employeeTextField now set to employee name selected
        let textFieldNameText = createReportVC!.textField.value as! String // Text in TextField after segue unwinds
        XCTAssertEqual(physicianRowName, textFieldNameText)
        
        createReportVC!.goToEmployeeTableView()
        seguedEmployeeTableView.selectRow(seguedEmployeeTableView.nurseRow)
        let nurseRowName = seguedEmployeeTableView.nurseNameTextView.label
        seguedEmployeeTableView.cancelSelection()
        
        // WHEN segue unwinds due to cancel button, no new value is set
        let updatedTextFieldNameText = createReportVC!.textField.value as! String // Text in TextField after segue unwinds
        XCTAssertNotEqual(nurseRowName, updatedTextFieldNameText)
        
        createReportVC!.goToEmployeeTableView()
        seguedEmployeeTableView.selectRow(seguedEmployeeTableView.nurseRow)
        seguedEmployeeTableView.finalizeSelection()
        // WHEN segue unwinds with selection due to done button, NEW value set
        let actuallyUpdatedTextFieldNameText = createReportVC!.textField.value as! String
        XCTAssertEqual(nurseRowName, actuallyUpdatedTextFieldNameText)
    }
    func testSaveNewReport() throws {
        throw XCTSkip("Need to set debug flag to force usage of dev server to prevent unnecessary PUT")
    }
}
