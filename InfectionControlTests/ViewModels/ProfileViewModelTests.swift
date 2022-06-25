//
//  ProfileViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

class ProfileViewModelTests: XCTestCase {
    var mockSession: MockURLSession!
    var mockNetworkManager: MockNetworkManager!
    var viewModel: ProfileViewModel!

    override func setUpWithError() throws {
        mockSession = MockURLSession()
        mockNetworkManager = MockNetworkManager(session: mockSession)
        viewModel = ProfileViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        mockSession = nil
        mockNetworkManager = nil
        viewModel = nil
    }

    func testEmployeeFetch() async throws {
        var cancellables = Set<AnyCancellable>()
        let employee = ModelsFactory.createEmployee(hasProfession: true)
        mockNetworkManager.replacementData = try! ModelsFactory.encoder().encode(EmployeeDTO(from: employee))
        var loadingNumUpdates = 0
        var modelNumUpdates = 0
        viewModel.$isLoadingEmployee.sink {
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables) // --F-T-F->
        viewModel.$employee.sink {
            modelNumUpdates == 0 ? XCTAssertNil($0) : XCTAssertEqual(employee.firstName, $0?.firstName)
            modelNumUpdates += 1
        }.store(in: &cancellables) // --nil--someEmployee-->
        await viewModel.fetchEmployeeInfo()
    }
    
    func testTeamFetch() async throws {
        var cancellables = Set<AnyCancellable>()
        let employeeDTOs = [EmployeeDTO(from: ModelsFactory.createEmployee())]
        mockNetworkManager.replacementData = try! ModelsFactory.encoder().encode(employeeDTOs)
        var loadingNumUpdates = 0
        var modelNumUpdates = 0
        viewModel.$isLoadingTeamList.sink {
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables) // --F-T-F->
        viewModel.$teamList.sink {
            if (modelNumUpdates == 0) { XCTAssert($0.isEmpty) }
            else { XCTAssertEqual(employeeDTOs[0].firstName, $0[0].firstName) }
            modelNumUpdates += 1
        }.store(in: &cancellables) // --nil--someEmployee-->
        await viewModel.fetchEmployeeInfo()
    }
    
    func testReportFetch() async throws {
        var cancellables = Set<AnyCancellable>()
        let reportDTOs = [ReportDTO(from: ModelsFactory.createReport())]
        mockNetworkManager.replacementData = try! ModelsFactory.encoder().encode(reportDTOs)
        var loadingNumUpdates = 0
        var modelNumUpdates = 0
        viewModel.$isLoadingReportList.sink {
            loadingNumUpdates % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingNumUpdates += 1
        }.store(in: &cancellables) // --F-T-F->
        viewModel.$reportList.sink {
            if (modelNumUpdates == 0) { XCTAssert($0.isEmpty) }
            else {
                XCTAssertEqual(reportDTOs[0].employee?.firstName, $0[0].employee.firstName)
                XCTAssertEqual(reportDTOs[0].healthPractice?.name, $0[0].healthPractice.name)
                XCTAssertEqual(reportDTOs[0].location?.facilityName, $0[0].location.facilityName)
            }
            modelNumUpdates += 1
        }.store(in: &cancellables) // --nil--someEmployee-->
        await viewModel.fetchEmployeeInfo()
    }

}
