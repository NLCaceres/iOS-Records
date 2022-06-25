//
//  CreateReportViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

class CreateReportViewModelTests: XCTestCase {
    var mockSession: MockURLSession!
    var mockNetworkManager: MockNetworkManager!
    var createReportViewModel: CreateReportViewModel!
    
    override func setUp() {
        mockSession = MockURLSession()
        mockNetworkManager = MockNetworkManager(session: mockSession)
        createReportViewModel = CreateReportViewModel(networkManager: mockNetworkManager)
    }
    override func tearDown() {
        createReportViewModel = nil
        mockNetworkManager = nil // Any replacementClosure becomes nil
        mockSession = nil
    }

    func testLoading() async {
        var cancellables: Set<AnyCancellable> = []
        var numTimesCalled = 0
        createReportViewModel.$isLoading.sink {
            numTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssert($0)
            numTimesCalled += 1
        }.store(in: &cancellables)
        await createReportViewModel.beginFetching() // Stream --F--T--F-->
        await createReportViewModel.postNewReport() // Stream --T--F-->
    }
    
    func testSaveButtonEnabled() async {
        var cancellables: Set<AnyCancellable> = []
        var numTimesCalled = 0
        createReportViewModel.saveButtonEnabled.sink {
            // Expected Stream = --F-F-F-T-T-->
            if numTimesCalled >= 3 { XCTAssert($0) }
            else { XCTAssertFalse($0) }
            numTimesCalled += 1
        }.store(in: &cancellables)
        createReportViewModel.reportEmployee = Employee(firstName: "foo", surname: "bar")
        createReportViewModel.reportHealthPractice = HealthPractice(name: "Foo")
        createReportViewModel.reportLocation = Location(facilityName: "foo", unitNum: "1", roomNum: "2")
        createReportViewModel.reportDate = Date(timeIntervalSinceNow: -3600) // Date is 3:00pm if currentTime is 4:00pm
    }
}
