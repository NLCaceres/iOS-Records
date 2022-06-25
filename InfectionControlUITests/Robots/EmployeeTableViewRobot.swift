//
//  EmployeeTableViewRobot.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class EmployeeTableViewRobot: Robot {
    // TODO: Find the nav buttons
    lazy var employeeListNav = self.app.navigationBars["Employee List"]
    lazy var cancelButton = self.employeeListNav.children(matching: .button)["Cancel"]
    lazy var selectButton = self.employeeListNav.children(matching: .button)["Select"]
    lazy var tableView = self.app.tables.firstMatch
    // Oddly .tableRows won't return what you'd expect, Got to use .cells
    lazy var tableRows = self.tableView.cells
    // Could be multiple rows that are there BUT we're just going to probably select this and move on
    lazy var physicianRow = self.tableRows.containing(.staticText, identifier: "Clinic Physician").firstMatch
    // Following uses predicate to match the name textView in our row by NOT matching the occupation textView
    // Could have used "NOT label == 'Clinic Physician'" BUT 'Physician' by itself + 'contains' is a bit more flexible
    lazy var physicianNameTextView = self.physicianRow.staticTexts.matching(NSPredicate(format: "NOT label contains 'Physician'")).element
    lazy var nurseRow = self.tableRows.containing(.staticText, identifier: "Clinic Nurse").firstMatch
    lazy var nurseNameTextView = self.nurseRow.staticTexts.matching(NSPredicate(format: "NOT label contains 'Nurse'")).element
    
    func selectRow() {
        self.physicianRow.tap()
    }
    func selectRow(_ givenRow: XCUIElement) {
        givenRow.tap()
    }
    func finalizeSelection() {
        self.selectButton.tap()
    }
    func cancelSelection() {
        self.cancelButton.tap()
    }
}
