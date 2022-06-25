//
//  ReportTableViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import RxSwift

class ReportTableViewModelTests: XCTestCase {
    var mockSession: MockURLSession!
    var mockNetworkManager: MockNetworkManager!
    var tableViewModel: ReportTableViewModel!
    
    override func setUp() {
        mockSession = MockURLSession()
        mockNetworkManager = MockNetworkManager(session: mockSession)
        tableViewModel = ReportTableViewModel(networkManager: mockNetworkManager)
    }
    override func tearDown() {
        tableViewModel = nil
        mockNetworkManager = nil // Any replacementClosure becomes nil
        mockSession = nil
    }
    
    func testGetReports() {
        // SETUP
        mockNetworkManager.setClosure { print("Alt closure called") } // Override closure for speed
        let disposeBag = DisposeBag()
        let assertData = AssertTimesCalled()
        // WHEN onNext 1st runs, it replays initVal which is false
        tableViewModel.isLoadingDisplay.subscribe(onNext: {
            assertData.numTimes == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            assertData.numTimes += 1
        }, onDisposed: {
            XCTAssertEqual(assertData.numTimes, 2)
        }).disposed(by: disposeBag)
        // WHEN getReport1st called, THEN true added to stream -F--> becomes -F-T-->
        tableViewModel.getReports()
        tableViewModel.getReports() // distinctUntilChanged makes stream = -F-T-->, NOT -F-T-T-->
    }
    
    func testSetupReportViewCellFailed() {
        // SETUP
        let replayExpectation = expectation(description: "Behavior replays getReports latest true")
        let guardedExpectation = expectation(description: "getReports call of setupReportViewCell adds false to stream")
        mockNetworkManager.setClosure { print("Alt closure called") } // Override closure for speed
        let assertData = AssertTimesCalled() // Track onNext calls
        let disposeBag = DisposeBag() // Dipose sub on test complete
        
        tableViewModel.getReports() // WHEN getReports() before subbing, behaviorRelay replays true
        tableViewModel.isLoadingDisplay.subscribe(onNext: {
            assertData.numTimes += 1
            if (assertData.numTimes > 1) {
                XCTAssertFalse($0) // 2nd getReport() so guard exits, feeding sub a false val
                guardedExpectation.fulfill()
            }
            else {
                XCTAssertTrue($0) // 1st = replay which returns true
                replayExpectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        mockNetworkManager.setClosure(nil) // Reset to nil, so WHEN getReports(), setupCell() runs, not the altClosure
        // WHEN mockSession provides nil data to setupCell() in getReports(), THEN isLoading still fed false!
        tableViewModel.getReports()
        waitForExpectations(timeout: 0.1) { _ in XCTAssertEqual(assertData.numTimes, 2, "Expectations fulfilled") }
    }
    func testSetupReportViewCellPositiveConditional() {
        // SETUP
        let disposeBag = DisposeBag()
        let mockReportDTOs: [ReportDTO] = (0...4).map { _ in ReportDTO(from: ModelsFactory.createReport()) }

        let reportsAddedExpectation = expectation(description: "Should get a [] of 5 viewCellModels")
        mockSession.data = try! ModelsFactory.encoder().encode(mockReportDTOs)
        tableViewModel.reportCellViewModels.subscribe(onNext: { // $0 == reportViewCellModels
            if ($0.count == 5) { reportsAddedExpectation.fulfill() }
        }).disposed(by: disposeBag)
        
        tableViewModel.getReports()
        waitForExpectations(timeout: 0.1)
    }
}
