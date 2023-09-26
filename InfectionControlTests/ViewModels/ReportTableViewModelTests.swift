//
//  ReportTableViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import RxSwift

class ReportTableViewModelTests: XCTestCase {
    var reportTableViewModel: ReportTableViewModel!
    var mockReportRepository: MockReportRepository!
    
    override func setUp() {
        mockReportRepository = MockReportRepository()
        mockReportRepository.populateList()
        reportTableViewModel = ReportTableViewModel(reportRepository: mockReportRepository)
    }
    
    func testGetReportsLoading() async throws {
        // SETUP
        let disposeBag = DisposeBag()
        XCTAssertNil(mockReportRepository.calledCount["getReportList()"])
        var loadingTimesCalled = 0
        // WHEN onNext 1st runs, it replays initVal which is false
        reportTableViewModel.isLoadingDisplay.subscribe(onNext: {
            loadingTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingTimesCalled += 1
        }).disposed(by: disposeBag)
        // WHEN getReportList is called, THEN "true" is added to the loading stream -F--> making -F-T-->
        await reportTableViewModel.getReportList()
        XCTAssertEqual(mockReportRepository.calledCount["getReportList()"], 1)
    }

    func testSetupReportViewCell() async throws {
        // SETUP
        let disposeBag = DisposeBag() // Dipose sub on test complete
        XCTAssertNil(mockReportRepository.calledCount["getReportList()"])
        // WHEN GetReportList called
        var reportCellTimesCalled = 0
        reportTableViewModel.reportCellViewModels.subscribe(onNext: {
            // THEN BehaviorRelay initially sends 0 report cells
            let expectedCount = reportCellTimesCalled == 0 ? 0 : 5
            XCTAssertEqual($0.count, expectedCount) // THEN after getting report list of 5 reports, now have 5 report cells
            reportCellTimesCalled += 1
        }).disposed(by: disposeBag)
        await reportTableViewModel.getReportList()
        XCTAssertEqual(mockReportRepository.calledCount["getReportList()"], 1)

        // WHEN GetReportList called, regardless of success or failure
        var loadingTimesCalled = 0
        reportTableViewModel.isLoadingDisplay.subscribe(onNext: {
            // THEN loading stream from BehaviorRelay = --F--T--F-->
            loadingTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingTimesCalled += 1
        }).disposed(by: disposeBag)
        
        // WHEN repository throws in getReports()
        let expectedErrMsg = "Get Report List failed!"
        reportTableViewModel.errMessage.subscribe(onNext: {
            // THEN error message is caught and saved
            XCTAssertEqual($0, expectedErrMsg)
        }).disposed(by: disposeBag)
        mockReportRepository.prepToThrow(description: expectedErrMsg)
        await reportTableViewModel.getReportList()
        
        XCTAssertEqual(mockReportRepository.calledCount["getReportList()"], 2)
    }
    // An alternative method for testing callback or promise based async programming is XCTestExpectations
    func testSetupReportViewCellWithExpectations() async throws {
        // SETUP
        let disposeBag = DisposeBag()
        XCTAssertNil(mockReportRepository.calledCount["getReportList()"])
        // Expect to get 5 tableView cells based on 5 returned reports
        let reportsAddedExpectation = expectation(description: "Should get a [] of 5 viewCellModels")
        reportTableViewModel.reportCellViewModels.subscribe(onNext: { // $0 == reportViewCellModels
            if ($0.count == 5) { reportsAddedExpectation.fulfill() }
        }).disposed(by: disposeBag)

        await reportTableViewModel.getReportList() // Fire off the "GET list" request
        await waitForExpectations(timeout: 0.1)
        XCTAssertEqual(mockReportRepository.calledCount["getReportList()"], 1)
    }
}
