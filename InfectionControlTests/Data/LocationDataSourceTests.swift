//
//  LocationDataSourceTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class LocationDataSourceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var locationApiDataSource: LocationApiDataSource!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        locationApiDataSource = LocationApiDataSource(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        locationApiDataSource = nil
    }
    
    func testGetLocationList() async throws {
        let expectedList = [Location(facilityName: "USC", unitNum: "2", roomNum: "123"), Location(facilityName: "HSC", unitNum: "4", roomNum: "202")]
        let locationDtoArray = [LocationDTO(from: expectedList[0]), LocationDTO(from: expectedList[1])]
        let jsonEncoder = defaultEncoder()
        let locationDtoArrayData = try? jsonEncoder.encode(locationDtoArray)
        mockNetworkManager.replacementData = locationDtoArrayData // Inject data that the networkManager will fetch
        
        let locationListResult = await locationApiDataSource.getLocationList() // Calls networkManager.fetch and parses the returned data
        XCTAssertEqual(try! locationListResult.get(), expectedList) // Using result.success(), we can get the decoded array
    }
}
