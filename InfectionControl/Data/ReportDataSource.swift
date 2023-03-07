//
//  ReportDataSource.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

protocol ReportDataSource {
    func getReportList() async -> Result<[Report], Error>
    func getReport(id: String) async -> Result<Report?, Error>
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
}

struct ReportApiDataSource: ReportDataSource {
    let networkManager: FetchingNetworkManager
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // TODO: ToBase protocol may need refactoring since both of these functions suffer from ToBase deciding the Base type is Report?
    // which causes it to double optional wrap "Report" into "Report??" and at least w/ "GET List" we are forced to run a second compactMap
    func getReportList() async -> Result<[Report], Error> {
        let reportArrResult = await getBaseArray(for: ReportDTO.self) { await networkManager.fetchTask(endpointPath: "/reports") }
        if case .failure(let error) = reportArrResult {
            return .failure(error)
        }
        let reportArr = try! reportArrResult.get() // Type here is actually Result<[Report?], Error>
        return .success(reportArr.compactMap { $0 }) // So have to compactMap it to get the desired/expected Result<[Report], Error>
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        let reportResult = await getBase(for: ReportDTO.self) { await networkManager.fetchTask(endpointPath: "/reports/\(id)") }
        if case .failure(let error) = reportResult {
            return .failure(error)
        }
        let report = try! reportResult.get()
        return .success(report ?? nil)
    }
}
