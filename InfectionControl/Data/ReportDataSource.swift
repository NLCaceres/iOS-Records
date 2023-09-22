//
//  ReportDataSource.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

protocol ReportDataSource {
    func getReportList() async -> Result<[Report], Error>
    func getReport(id: String) async -> Result<Report?, Error>
    func createNewReport(_ newReport: Report) async -> Result<Report?, Error>
}

struct ReportCoreDataSource: ReportDataSource {
    func getReportList() async -> Result<[Report], Error> {
        print("Get the Employee List from CoreData")
        return .success([])
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        print("Get one Employee from CoreData")
        return .success(nil)
    }
    
    func createNewReport(_ newReport: Report) async -> Result<Report?, Error> {
        return .failure(NSError())
    }
}

struct ReportApiDataSource: ReportDataSource {
    let networkManager: CompleteNetworkManager
    
    init(networkManager: CompleteNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // TODO: ToBase protocol may need refactoring since both of these functions suffer from ToBase deciding the Base type is Report?
    // which causes it to double optional wrap "Report" into "Report??" and at least w/ "GET List" we are forced to run a second compactMap
    func getReportList() async -> Result<[Report], Error> {
        let reportArrResult = await getBaseArray(for: ReportDTO.self) { await networkManager.fetchTask(endpointPath: "/reports") }
        return Result { try reportArrResult.get().compactMap { $0 } } // Need compactMap() to get the desired/expected Result<[Report], Error>
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        let reportResult = await getBase(for: ReportDTO.self) { await networkManager.fetchTask(endpointPath: "/reports/\(id)") }
        return Result { try reportResult.get() ?? nil } // Similarly, need to unwrap "Report??" to simple "Report?"
    }
    
    func createNewReport(_ newReport: Report) async -> Result<Report?, Error> {
        let reportResult = await getBase(for: ReportDTO.self) {
            await networkManager.sendPostRequest(with: ReportDTO(from: newReport), endpointPath: "/reports")
        }
        return Result { try reportResult.get() ?? nil }
    }
}
