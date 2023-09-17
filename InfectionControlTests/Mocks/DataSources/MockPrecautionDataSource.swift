//
//  MockPrecautionDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockPrecautionDataSource: PrecautionDataSource {
    var precautionList: [Precaution] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func getPrecautionList() async -> Result<[Precaution], Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(precautionList)
    }
    
    // By making this dataSource a class, no wasteful "mutating" funcs are needed! Modify the dataSource as much as needed!
    func populateList() {
        precautionList = DataFactory.makePrecautions()
    }
    func prepToThrow() {
        error = NSError()
    }
}
