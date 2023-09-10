//
//  LocationRepository.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol LocationRepository {
    func getLocationList() async throws -> [Location]
}

struct AppLocationRepository: LocationRepository {
    let locationApiDataSource: LocationDataSource
    let locationCoreDataSource: LocationDataSource
    
    init(locationApiDataSource: LocationDataSource = LocationApiDataSource(),
         locationCoreDataSource: LocationDataSource = LocationCoreDataSource()) {
        self.locationApiDataSource = locationApiDataSource
        self.locationCoreDataSource = locationCoreDataSource
    }
    
    func getLocationList() async throws -> [Location] {
        return try await getEntity { await locationApiDataSource.getLocationList() }
    }
}
