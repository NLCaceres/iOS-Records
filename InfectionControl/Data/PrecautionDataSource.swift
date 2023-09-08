//
//  PrecautionDataSource.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol PrecautionDataSource {
    func getPrecautionList() async -> Result<[Precaution], Error>
}

/* For fetching from CoreData */
struct PrecautionCoreDataSource: PrecautionDataSource {
    func getPrecautionList() async -> Result<[Precaution], Error> {
        print("Get the Precaution List from CoreData")
        return .success([])
    }
}

/* Fetch from the API backend */
struct PrecautionApiDataSource: PrecautionDataSource {
    let networkManager: FetchingNetworkManager
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPrecautionList() async -> Result<[Precaution], Error> {
        return await getBaseArray(for: PrecautionDTO.self) { await networkManager.fetchTask(endpointPath: "/precautions") }
    }
}
