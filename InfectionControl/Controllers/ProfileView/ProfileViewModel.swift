//
//  ProfileViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

class ProfileViewModel: ObservableObject {
    private let employeeRepository: EmployeeRepository
    private let reportRepository: ReportRepository
    private let networkManager: FetchingNetworkManager
    @Published private(set) var isLoadingEmployee = false
    @Published private(set) var isLoadingTeamList = false
    @Published private(set) var isLoadingReportList = false
    
    @Published var employee: Employee?
    @Published var employeeImg: UIImage?
    @Published var teamList: [Employee] = []
    @Published var reportList: [Report] = [] // Could be individual reports or an entire team's reports
    
    init(networkManager: FetchingNetworkManager = NetworkManager(), employeeRepository: EmployeeRepository = AppEmployeeRepository(),
         reportRepository: ReportRepository = AppReportRepository()) {
        self.networkManager = networkManager
        self.employeeRepository = employeeRepository
        self.reportRepository = reportRepository
    }
    
    // Adding @MainActor forces SwiftUI Views to update on the MainThread (even though @StateObj + @ObservedObj technically already do)
    @MainActor // Particularly important when async/await is used
    func fetchEmployeeInfo(employeeID: String = "5ce0f954a146f105626719b7") async {
        print("Fetching employee info from profileViewModel")
        isLoadingEmployee = true // Publishes change so view can display refreshControl
        // TODO: Save ID in UserDefaults? This ID belongs to logged in user
        do {
            employee = try await employeeRepository.getEmployee(id: employeeID)
        } catch {
            print("Got the following error while fetching this employee - \(employeeID): \(error.localizedDescription)")
        }
        isLoadingEmployee = false
    }
    @MainActor // TODO: To prevent having a NetworkManager dependency, abstract away a image fetching API/dataSource/Repository
    func fetchEmployeeImage(urlPath: String, networkManager: FetchingNetworkManager) async {
        let employeeImgResult = await networkManager.fetchData(endpointPath: urlPath)
        if case let .failure(error) = employeeImgResult { // Early return if condition
            print("Got the following error \(error.localizedDescription)")
            return
        }
        let employeeImgData = try! employeeImgResult.get() // Should not be able to throw anymore!
        if let data = employeeImgData { employeeImg = UIImage(data: data) }
    }
    
    @MainActor
    func fetchReports(endpointPath: String = "reports") async {
        print("Fetching report info from profileViewModel")
        isLoadingReportList = true
        do {
            reportList = try await reportRepository.getReportList()
        } catch {
            print("Got the following error while fetching reports: \(error.localizedDescription)")
            reportList = []
        }
        isLoadingReportList = false
    }
    @MainActor
    func fetchTeam() async {
        print("Fetching team info from profileViewModel")
        isLoadingTeamList = true
        do {
            teamList = try await employeeRepository.getEmployeeList()
        } catch {
            print("Got the following error while fetching the team of this employee - \(employee?.id ?? "Missing ID"): \(error.localizedDescription)")
        }
        isLoadingTeamList = false
    }
    
}
