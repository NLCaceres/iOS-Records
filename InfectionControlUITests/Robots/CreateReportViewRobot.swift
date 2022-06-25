//
//  CreateReportViewRobot.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class CreateReportViewRobot: Robot {
    lazy var textField = self.app.textFields.firstMatch
    lazy var datePicker = self.app.datePickers.firstMatch
    lazy var normalPickers = self.app.pickers
    
    @discardableResult
    func goToEmployeeTableView() -> EmployeeTableViewRobot {
        self.textField.doubleTap()
        return EmployeeTableViewRobot(app: self.app)
    }
}
