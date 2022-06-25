//
//  BaseRobots.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

/* Could include more but tap() and exists prop handle common basic functionality */
class Robot {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }
}

enum LoadingError: Error {
    case unsuccessful
}

@discardableResult
func commonAppSetup(app: XCUIApplication, args: [String]) throws -> CreateReportCvRobot {
    for launchArg in args {
        app.launchArguments.append(launchArg)
    }
    app.launch()
    
    let createReportCV = CreateReportCvRobot(app: app)
    guard createReportCV.successfulLoad() else { XCTFail("Setup failed"); throw LoadingError.unsuccessful }
    
    return createReportCV
}

extension XCUIElementQuery {
    func eliminateScrollbars() -> XCUIElementQuery {
        return self.matching(NSPredicate(format: "NOT label contains 'scroll bar'"))
    }
}

class TabViewRobot: Robot {
    lazy var tabBar = self.app.tabBars.firstMatch
    lazy private var profileTabButton = self.tabBar.buttons["Profile"]
    lazy private var createReportCvTabButton = self.tabBar.buttons["New Report"]
    lazy private var reportsTabButton = self.tabBar.buttons["Reports"]
    lazy private var settingsTabButton = self.tabBar.buttons["Settings"]
    
    func goToProfileView() -> ProfileViewRobot {
        profileTabButton.tap()
        return ProfileViewRobot(app: self.app)
    }
    func goToCreateReportCV() -> CreateReportCvRobot {
        createReportCvTabButton.tap()
        return CreateReportCvRobot(app: self.app)
    }
    func goToReportTableView() -> ReportTableViewRobot {
        reportsTabButton.tap()
        return ReportTableViewRobot(app: self.app)
    }
    func goToSettingsView() -> SettingsViewRobot {
        settingsTabButton.tap()
        return SettingsViewRobot(app: self.app)
    }
}
