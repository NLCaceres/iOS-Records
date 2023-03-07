//
//  ReportTableViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import RxSwift

class ReportTableViewModelTests: XCTestCase {
    func testGetReports() async throws {
        // SETUP
        let mockRepository = MockReportRepository(reportList: [
            Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
            Report(employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        ])
        let tableViewModel = ReportTableViewModel(reportRepository: mockRepository)
        let disposeBag = DisposeBag()
        
        var loadingTimesCalled = 0
        // WHEN onNext 1st runs, it replays initVal which is false
        tableViewModel.isLoadingDisplay.subscribe(onNext: {
            loadingTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingTimesCalled += 1
        }).disposed(by: disposeBag)
        // WHEN getReportList is called, THEN "true" is added to the loading stream -F--> making -F-T-->
        await tableViewModel.getReportList()
    }
    
    func testSetupReportViewCell() async throws {
        // SETUP
        let mockRepository = MockReportRepository(reportList: [
            Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
            Report(employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        ])
        let tableViewModel = ReportTableViewModel(reportRepository: mockRepository)
        let disposeBag = DisposeBag() // Dipose sub on test complete
        
        var reportCellTimesCalled = 0
        tableViewModel.reportCellViewModels.subscribe(onNext: {
            let expectedCount = reportCellTimesCalled == 0 ? 0 : 2 // Initially have 0 report cells
            XCTAssertEqual($0.count, expectedCount) // After getting report list of 2 reports, now have 2 report cells
            reportCellTimesCalled += 1
        }).disposed(by: disposeBag)
        await tableViewModel.getReportList()
        
        let throwingRepository = MockReportRepository(error: NSError())
        let thrownTableViewModel = ReportTableViewModel(reportRepository: throwingRepository)
        var loadingTimesCalled = 0
        thrownTableViewModel.isLoadingDisplay.subscribe(onNext: {
            loadingTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingTimesCalled += 1
        }).disposed(by: disposeBag)
        // WHEN repository throws in getReports(), THEN isLoading still fed false!
        await thrownTableViewModel.getReportList()
    }
    func testSetupReportViewCellPositiveConditional() async throws {
        // SETUP
        let mockRepository = MockReportRepository(reportList: [
            Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
            Report(employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        ])
        let tableViewModel = ReportTableViewModel(reportRepository: mockRepository)
        let disposeBag = DisposeBag()

        // Expect to get 2 tableView cells based on the 2 above reports
        let reportsAddedExpectation = expectation(description: "Should get a [] of 2 viewCellModels")
        tableViewModel.reportCellViewModels.subscribe(onNext: { // $0 == reportViewCellModels
            if ($0.count == 2) { reportsAddedExpectation.fulfill() }
        }).disposed(by: disposeBag)
        
        await tableViewModel.getReportList() // Fire off the "GET list" request
        await waitForExpectations(timeout: 0.1)
    }
}
