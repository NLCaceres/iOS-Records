//
//  CreateReportCvRobot.swift
//  InfectionControlUITests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import XCTest

/* App Starts on this tab: CreateReportCollectionView
 So use this robot to navigate across tabs and views */
class CreateReportCvRobot: TabViewRobot {
    // MARK: Major properties of the collectionView
    lazy var thisCollectionView = self.app.collectionViews.firstMatch
    lazy var cvSectionHeaders = self.app.collectionViews.children(matching: .other).eliminateScrollbars()
    lazy var allCells = self.app.collectionViews.cells
    lazy private var handHygieneCell = self.thisCollectionView.cells.containing(.staticText, identifier: "Hand Hygiene").element
    
    func successfulLoad() -> Bool { // Important to call. Need to ensure CELLS loaded on screen at all
        // Waiting for collectionView is bad. It's ALWAYS there even if empty. Either wait for all cells or a specific one.
        guard self.allCells.firstMatch.waitForExistence(timeout: 20) else {
            XCTFail("Server asleep. Can't fill collectionView"); return false
        }
        return true
    }
    
    @discardableResult
    func goToCreateReportView() -> CreateReportViewRobot {
        // Should always grab handHygiene cell so onNav "Choose Health Practice" picker defaults to "Hand Hygiene"
        handHygieneCell.tap()
        return CreateReportViewRobot(app: self.app)
    }
}

