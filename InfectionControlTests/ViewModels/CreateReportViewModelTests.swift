//
//  CreateReportViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

class CreateReportViewModelTests: XCTestCase {
    var createReportViewModel: CreateReportViewModel!
    var mockHealthPracticeRepository: MockHealthPracticeRepository!
    var mockLocationRepository: MockLocationRepository!
    var mockReportRepository: MockReportRepository!
    
    override func setUp() {
        mockHealthPracticeRepository = MockHealthPracticeRepository()
        mockHealthPracticeRepository.populateList()
        mockLocationRepository = MockLocationRepository()
        mockLocationRepository.populateList()
        mockReportRepository = MockReportRepository()
        mockReportRepository.populateList()
        createReportViewModel = CreateReportViewModel(healthPracticeRepository: mockHealthPracticeRepository,
                                                      locationRepository: mockLocationRepository, reportRepository: mockReportRepository)
    }

    func testLoading() async {
        var cancellables: Set<AnyCancellable> = []
        var numTimesCalled = 0
        createReportViewModel.$isLoading.sink {
            numTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssert($0)
            numTimesCalled += 1
        }.store(in: &cancellables)
        // 1st emitted value is always False then all requests emit True followed by False on completion
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
        
        fillReportData()
    }
    
    func testPostNewReport() async {
        var cancellables: Set<AnyCancellable> = []
        var numTimesCalled = 0
        createReportViewModel.$isLoading.sink { // Expected: 1st = ---False--True--F--> THEN all others = --T--F-->
            numTimesCalled % 2 == 0 ? XCTAssertFalse($0) : XCTAssert($0)
            numTimesCalled += 1
        }.store(in: &cancellables)
        
        // WHEN no report data input
        await createReportViewModel.postNewReport()
        // THEN guard return hit due to nil values, defer should run to end load, without calling createNewReport()
        XCTAssertNil(mockReportRepository.calledCount["createNewReport(_:)"]) // So no key/val pair in the dictionary yet
        
        // WHEN report data input completely
        fillReportData()
        await createReportViewModel.postNewReport()
        // THEN createNewReport called, completed and old input data cleared as view returns to ReportList
        XCTAssertEqual(mockReportRepository.calledCount["createNewReport(_:)"], 1)
        XCTAssertNil(createReportViewModel.reportEmployee)
        XCTAssertNil(createReportViewModel.reportHealthPractice)
        XCTAssertNil(createReportViewModel.reportLocation)
        XCTAssertNil(createReportViewModel.reportDate)

        // WHEN error occurs
        fillReportData()
        let errMessage = "Post request failed"
        mockReportRepository.prepToThrow(description: errMessage)
        await createReportViewModel.postNewReport()
        // THEN it is caught and error message should be rendered
        XCTAssertEqual(createReportViewModel.errorMessage, errMessage)
    }
    private func fillReportData() {
        createReportViewModel.reportEmployee = mockReportRepository.reportList.first?.employee
        createReportViewModel.reportHealthPractice = mockReportRepository.reportList.first?.healthPractice
        createReportViewModel.reportLocation = mockReportRepository.reportList.first?.location
        createReportViewModel.reportDate = mockReportRepository.reportList.first?.date
    }
}
