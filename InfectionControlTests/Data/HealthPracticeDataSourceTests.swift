//
//  HealthPracticeDataSourceTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class HealthPracticeDataSourceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var healthPracticeApiDataSource: HealthPracticeApiDataSource!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        healthPracticeApiDataSource = HealthPracticeApiDataSource(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        healthPracticeApiDataSource = nil
    }
    
    func testGetHealthPracticeList() async throws {
        let expectedList = [HealthPractice(name: "Hand Hygiene"), HealthPractice(name: "Contact")]
        let healthPracticeDtoArray = [HealthPracticeDTO(from: expectedList[0]), HealthPracticeDTO(from: expectedList[1])]
        let jsonEncoder = JSONEncoder()
        let healthPracticeDtoArrayData = try? jsonEncoder.encode(healthPracticeDtoArray)
        mockNetworkManager.replacementData = healthPracticeDtoArrayData // Inject data that the networkManager will fetch
        
        let healthPracticeListResult = await healthPracticeApiDataSource.getHealthPracticeList() // Calls networkManager.fetch and parses the returned data
        XCTAssertEqual(try! healthPracticeListResult.get(), expectedList) // Using result.success(), we can get the decoded array
    }
}
