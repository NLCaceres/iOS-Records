//
//  PrecautionRepositoryTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class PrecautionRepositoryTests: XCTestCase {
    func testGetPrecautionList() async throws {
        let mockDataSource = MockPrecautionDataSource()
        let precautionRepository = AppPrecautionRepository(precautionApiDataSource: mockDataSource)
        
        let emptyPrecautionList = try! await precautionRepository.getPrecautionList()
        XCTAssertNotNil(emptyPrecautionList) // Sanity check that defaults to an empty list, not nil
        XCTAssertEqual(emptyPrecautionList.count, 0)
        
        mockDataSource.populateList()
        let filledPrecautionList = try! await precautionRepository.getPrecautionList()
        XCTAssertEqual(filledPrecautionList.count, 2) // After populating list, we now have 2 Precautions
        
        let standardPrecaution = filledPrecautionList[0]
        XCTAssertNotNil(standardPrecaution.practices)
        XCTAssertEqual(standardPrecaution.practices!.count, 2)
        let isolationPrecaution = filledPrecautionList[1]
        XCTAssertNotNil(isolationPrecaution.practices)
        XCTAssertEqual(isolationPrecaution.practices!.count, 4)
        
        mockDataSource.prepToThrow()
        let nilPrecautionList = try? await precautionRepository.getPrecautionList()
        XCTAssertNil(nilPrecautionList) // On fail, using "try?" causes thrown errors to return "nil"
        
        XCTAssertEqual(mockDataSource.calledCount["getPrecautionList()"]!, 3)
    }
}
