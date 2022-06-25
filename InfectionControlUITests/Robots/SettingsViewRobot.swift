//
//  SettingsViewRobot.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

class SettingsViewRobot: TabViewRobot {
    lazy var switches = self.app.tables.cells.switches // Currrently gets 2 (1 for the parent cell, 1 for the button)
    lazy var colorPickers = self.app.tables.cells.images.matching(identifier: "UIColorWell") // .colorWells doesn't find them
    lazy var steppers = self.app.tables.cells.steppers
    
    lazy var organizationSection = self.app.tables.children(matching: .other).containing(.staticText, identifier: "Organization")
    
    lazy var darkModeCell = self.app.tables.cells.matching(NSPredicate(format: "label contains 'Dark Mode'"))
    lazy var colorPickerCells = self.app.tables.cells.containing(.image, identifier: "UIColorWell")
    lazy var stepperCells = self.app.tables.cells.containing(.stepper, identifier: nil)
}
