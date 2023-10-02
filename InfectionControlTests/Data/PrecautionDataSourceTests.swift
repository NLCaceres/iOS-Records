//
//  PrecautionDataSourceTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class PrecautionDataSourceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var precautionApiDataSource: PrecautionApiDataSource!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        precautionApiDataSource = PrecautionApiDataSource(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        precautionApiDataSource = nil
    }
    
    func testGetPrecautionList() async throws {
        let expectedList = [Precaution(name: "Standard"), Precaution(name: "Isolation")]
        let precautionDtoArray = [PrecautionDTO(from: expectedList[0]), PrecautionDTO(from: expectedList[1])]
        let jsonEncoder = defaultEncoder()
        let precautionDtoArrayData = try? jsonEncoder.encode(precautionDtoArray)
        mockNetworkManager.replacementData = precautionDtoArrayData // Inject data that the networkManager will fetch
        
        let precautionListResult = await precautionApiDataSource.getPrecautionList() // Calls networkManager.fetch and parses the returned data
        XCTAssertEqual(try! precautionListResult.get(), expectedList) // Using result.success(), we can get the decoded array
    }
}
