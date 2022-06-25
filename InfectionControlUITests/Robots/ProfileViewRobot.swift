//
//  ProfileViewRobot.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class ProfileViewRobot: TabViewRobot {
    lazy var loadingIndicators = self.app.activityIndicators
    lazy var segmentedControl = self.app.segmentedControls.firstMatch // Should only be one
    lazy var listViews = self.app.tables
    lazy var reportList = self.app.tables
    lazy var employeeList = self.app.tables
}
