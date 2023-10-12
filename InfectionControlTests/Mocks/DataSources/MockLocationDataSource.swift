//
//  MockLocationDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockLocationDataSource: LocationDataSource {
    var locationList: [Location] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    // By making this dataSource a class, no wasteful "mutating" funcs are needed! Modify the dataSource as much as needed!
    func populateList() {
        locationList = DataFactory.makeLocations()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Location Data Source")
    }
    
    func getLocationList() async -> Result<[Location], Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(locationList)
    }
}
