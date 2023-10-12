//
//  MockHealthPracticeDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockHealthPracticeDataSource: HealthPracticeDataSource {
    var healthPracticeList: [HealthPractice] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    // By making this dataSource a class, no wasteful "mutating" funcs are needed! Modify the dataSource as much as needed!
    func populateList() {
        healthPracticeList = DataFactory.makeHealthPractices()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in HealthPractice Data Source")
    }
    
    func getHealthPracticeList() async -> Result<[HealthPractice], Error> {
        let funcName = #function // A freestanding macro that returns the calling func's name as a String, so "getHealthPracticeList()"
        calledCount[funcName, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(healthPracticeList)
    }
}
