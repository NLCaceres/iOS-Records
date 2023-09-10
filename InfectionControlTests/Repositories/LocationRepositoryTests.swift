//
//  LocationRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class LocationRepositoryTests: XCTestCase {
    func testGetLocationList() async throws {
        let mockDataSource = MockLocationDataSource()
        let locationRepository = AppLocationRepository(locationApiDataSource: mockDataSource)
        
        let emptyLocationList = try! await locationRepository.getLocationList()
        XCTAssertNotNil(emptyLocationList) // Sanity check that defaults to an empty list, not nil
        XCTAssertEqual(emptyLocationList.count, 0)
        
        mockDataSource.populateList()
        let filledLocationList = try! await locationRepository.getLocationList()
        XCTAssertEqual(filledLocationList.count, 5) // After populating list, we now have 5 Locations
        
        mockDataSource.prepToThrow()
        let nilLocationList = try? await locationRepository.getLocationList()
        XCTAssertNil(nilLocationList) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getLocationList()"]!, 3)
    }
}
