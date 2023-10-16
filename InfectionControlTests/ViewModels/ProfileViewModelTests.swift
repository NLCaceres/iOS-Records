//
//  ProfileViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

class ProfileViewModelTests: XCTestCase {
    var employeeRepository: MockEmployeeRepository!
    var reportRepository: MockReportRepository!
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        employeeRepository = MockEmployeeRepository()
        employeeRepository.populateList()
        reportRepository = MockReportRepository()
        reportRepository.populateList()
        viewModel = ProfileViewModel(employeeRepository: employeeRepository, reportRepository: reportRepository)
    }

    func testEmployeeFetch() async throws { // Fetch user's employee profile info
        var cancellables = Set<AnyCancellable>()

        var loadingNumUpdates = 0
        viewModel.$isLoadingEmployee.sink { // --F-T-F->
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables)

        var modelNumUpdates = 0
        viewModel.$employee.sink { // --nil--someEmployee-->
            modelNumUpdates == 0 ? XCTAssertNil($0) : XCTAssertEqual($0?.fullName, "John Smith")
            modelNumUpdates += 1
        }.store(in: &cancellables)

        await viewModel.fetchEmployeeInfo()
    }
    func testEmployeeImgURL() async throws {
        XCTAssertNil(viewModel.employeeImgURL)
        
        await viewModel.fetchEmployeeInfo()

        let expectedURL = viewModel.employeeImgURL! // Good quick nil check via "!" forced unwrap
        XCTAssertEqual(expectedURL.absoluteString, "some_url")
    }

    func testTeamFetch() async throws {
        var cancellables = Set<AnyCancellable>()

        var loadingNumUpdates = 0
        viewModel.$isLoadingTeamList.sink { // --F-T-F->
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables)

        var modelNumUpdates = 0
        viewModel.$teamList.sink { // --[]--[employee1, employee2]-->
            if (modelNumUpdates == 0) { XCTAssert($0.isEmpty) }
            else {
                XCTAssertEqual($0.count, 5)
                XCTAssertEqual($0[0].fullName, "John Smith")
            }
            modelNumUpdates += 1
        }.store(in: &cancellables)

        await viewModel.fetchEmployeeInfo()
    }

    func testReportFetch() async throws {
        var cancellables = Set<AnyCancellable>()

        var loadingNumUpdates = 0
        viewModel.$isLoadingReportList.sink { // --F-T-F->
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables)

        var modelNumUpdates = 0
        viewModel.$reportList.sink { reportList in // --[]--[report1, report2]-->
            if (modelNumUpdates == 0) { XCTAssert(reportList.isEmpty) }
            else {
                XCTAssertEqual(reportList.count, 5)
                XCTAssertEqual(reportList[0].employee.fullName, "John Smith")
                XCTAssertEqual(reportList[0].healthPractice.name, "Hand Hygiene")
                XCTAssertEqual(reportList[0].location.facilityName, "USC")
            }
            modelNumUpdates += 1
        }.store(in: &cancellables)
        await viewModel.fetchEmployeeInfo()
    }
}
