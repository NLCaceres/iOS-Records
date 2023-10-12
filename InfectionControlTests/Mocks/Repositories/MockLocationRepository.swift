//
//  MockLocationRepository.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockLocationRepository: LocationRepository {
    var locationList: [Location] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func populateList() {
        locationList = DataFactory.makeLocations()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Location Repository")
    }
    
    func getLocationList() async throws -> [Location] {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return locationList
    }
}
