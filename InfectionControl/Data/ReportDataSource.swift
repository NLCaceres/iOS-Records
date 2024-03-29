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
    
    init(networkManager: CompleteNetworkManager = AppNetworkManager()) {
        self.networkManager = networkManager
    }
    
    // TODO: BaseTypeConvertible protocol may need refactoring since both of these functions suffer from Report? becoming the inferred Base type,
    // causing it to double optional wrap "Report" into "Report??", so "GET List" needs compactMap() from getBaseArray AND in Result
    func getReportList() async -> Result<[Report], Error> {
        let reportArrResult = await getBaseArray(for: ReportDTO.self) { await networkManager.fetchData(endpointPath: "/reports") }
        return Result { try reportArrResult.get().compactMap { $0 } } // Need compactMap() to get the desired/expected Result<[Report], Error>
    }
    
    func getReport(id: String) async -> Result<Report?, Error> {
        let reportResult = await getBase(for: ReportDTO.self) { await networkManager.fetchData(endpointPath: "/reports/\(id)") }
        return Result { try reportResult.get() ?? nil } // Similarly, need to unwrap "Report??" to simple "Report?"
    }
    
    func createNewReport(_ newReport: Report) async -> Result<Report?, Error> {
        let reportResult = await getBase(for: ReportDTO.self) {
            await networkManager.sendPostRequest(with: ReportDTO(from: newReport), endpointPath: "/reports")
        }
        return Result { try reportResult.get() ?? nil }
    }
}
