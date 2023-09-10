//
//  HealthPracticeRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class HealthPracticeRepositoryTests: XCTestCase {
    func testGetHealthPracticeList() async throws {
        let mockDataSource = MockHealthPracticeDataSource()
        let healthPracticeRepository = AppHealthPracticeRepository(healthPracticeApiDataSource: mockDataSource)
        
        let emptyHealthPracticeList = try! await healthPracticeRepository.getHealthPracticeList()
        XCTAssertNotNil(emptyHealthPracticeList) // Sanity check that defaults to an empty list, not nil
        XCTAssertEqual(emptyHealthPracticeList.count, 0)
        
        mockDataSource.populateList()
        let filledHealthPracticeList = try! await healthPracticeRepository.getHealthPracticeList()
        XCTAssertEqual(filledHealthPracticeList.count, 6) // After populating list, we now have 6 HealthPractices
        
        mockDataSource.prepToThrow()
        let nilHealthPracticeList = try? await healthPracticeRepository.getHealthPracticeList()
        XCTAssertNil(nilHealthPracticeList) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getHealthPracticeList()"]!, 3) // Key requires the parentheses
    }
}
