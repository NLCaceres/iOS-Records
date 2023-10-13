//
//  LocationDataSource.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol LocationDataSource {
    func getLocationList() async -> Result<[Location], Error>
}

/* For fetching from CoreData */
struct LocationCoreDataSource: LocationDataSource {
    func getLocationList() async -> Result<[Location], Error> {
        print("Get the Location List from CoreData")
        return .success([])
    }
}

/* Fetch from the API backend */
struct LocationApiDataSource: LocationDataSource {
    let networkManager: FetchingNetworkManager
    
    init(networkManager: FetchingNetworkManager = AppNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getLocationList() async -> Result<[Location], Error> {
        return await getBaseArray(for: LocationDTO.self) { await networkManager.fetchData(endpointPath: "/locations") }
    }
}
