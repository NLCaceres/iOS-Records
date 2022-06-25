//
//  ProfileViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

class ProfileViewModel: ObservableObject {
    private let networkManager: FetchingNetworkManager
    @Published private(set) var isLoadingEmployee = false
    @Published private(set) var isLoadingTeamList = false
    @Published private(set) var isLoadingReportList = false
    
    @Published var employee: Employee?
    @Published var employeeImg: UIImage?
    @Published var teamList: [Employee] = []
    @Published var reportList: [Report] = [] // Could be individual reports or an entire team's reports
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // Adding @MainActor forces SwiftUI Views to update on the MainThread (even though @StateObj + @ObservedObj technically already do)
    @MainActor // Particularly important when async/await is used
    func fetchEmployeeInfo(employeeID: String = "5ce0f954a146f105626719b7") async {
        print("Fetching employee info from profileViewModel")
        isLoadingEmployee = true // Publishes change so view can display refreshControl
        // TODO: Save ID in UserDefaults? This ID belongs to logged in user
        employee = await fetchDTO(endpointPath: "employee/\(employeeID)", for: EmployeeDTO.self, networkManager: networkManager)
//        employee = Employee(firstName: "Nick", surname: "Caceres", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Supervisor"))
        isLoadingEmployee = false
    }
    @MainActor
    func fetchEmployeeImage(urlPath: String, networkManager: FetchingNetworkManager) async {
        let employeeImgData = await networkManager.fetchTask(endpointPath: urlPath)
        if let data = employeeImgData { employeeImg = UIImage(data: data) }
    }
    
    @MainActor
    func fetchReports(endpointPath: String = "reports") async {
        print("Fetching report info from profileViewModel")
        isLoadingReportList = true
        let reportOptList = await fetchDTOArr(endpointPath: endpointPath, containing: ReportDTO.self, networkManager: networkManager)
        reportList = reportOptList.compactMap { $0 }
        isLoadingReportList = false
    }
    @MainActor
    func fetchTeam(endpointPath: String = "employees") async {
        print("Fetching team info from profileViewModel")
        isLoadingTeamList = true
        teamList = await fetchDTOArr(endpointPath: endpointPath, containing: EmployeeDTO.self, networkManager: networkManager)
        isLoadingTeamList = false
    }
    
}
