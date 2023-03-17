//
//  ProfileViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

class ProfileViewModelTests: XCTestCase {
    //TODO: Test fetching employee image

    func testEmployeeFetch() async throws { // Fetch user's employee profile info
        let employeeRepository = MockEmployeeRepository(employee: Employee(firstName: "John", surname: "Smith"))
        let viewModel = ProfileViewModel(
            networkManager: MockNetworkManager(), employeeRepository: employeeRepository, reportRepository: MockReportRepository()
        )
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
    
    func testTeamFetch() async throws {
        let employeeRepository = MockEmployeeRepository(
            employeeList: [Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Melody", surname: "Rios")]
        )
        let viewModel = ProfileViewModel(
            networkManager: MockNetworkManager(), employeeRepository: employeeRepository, reportRepository: MockReportRepository()
        )
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
                XCTAssertEqual($0.count, 2)
                XCTAssertEqual($0[0].fullName, "John Smith")
            }
            modelNumUpdates += 1
        }.store(in: &cancellables)
        
        await viewModel.fetchEmployeeInfo()
    }
    
    func testReportFetch() async throws {
        let reportRepository = MockReportRepository(reportList: [
            Report(employee: Employee(firstName: "John", surname: "Smith"), healthPractice: HealthPractice(name: "Hand Hygiene"),
                   location: Location(facilityName: "USC", unitNum: "2", roomNum: "123"), date: Date()),
            Report(employee: Employee(firstName: "Melody", surname: "Rios"), healthPractice: HealthPractice(name: "PPE"),
                   location: Location(facilityName: "HSC", unitNum: "3", roomNum: "213"), date: Date())
        ])
        let viewModel = ProfileViewModel(
            networkManager: MockNetworkManager(), employeeRepository: MockEmployeeRepository(), reportRepository: reportRepository
        )
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
                XCTAssertEqual(reportList.count, 2)
                XCTAssertEqual(reportList[0].employee.fullName, "John Smith")
                XCTAssertEqual(reportList[0].healthPractice.name, "Hand Hygiene")
                XCTAssertEqual(reportList[0].location.facilityName, "USC")
            }
            modelNumUpdates += 1
        }.store(in: &cancellables)
        await viewModel.fetchEmployeeInfo()
    }

}
