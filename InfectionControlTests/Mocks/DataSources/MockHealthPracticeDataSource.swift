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
    
    func getHealthPracticeList() async -> Result<[HealthPractice], Error> {
        let funcName = #function // A freestanding macro that returns the calling func's name as a String, so "getHealthPracticeList()"
        calledCount[funcName, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(healthPracticeList)
    }
    
    // By making this dataSource a class, no wasteful "mutating" funcs are needed! Modify the dataSource as much as needed!
    func populateList() {
        healthPracticeList = MockHealthPracticeDataSource.makeList()
    }
    func prepToThrow() {
        error = NSError()
    }
    
    static func makeList() -> [HealthPractice] {
        let standardPrecaution = Precaution(name: "Standard")
        let isolationPrecaution = Precaution(name: "Isolation")
        
        return [ // All IDs are nil by default, if needed, but may need a version that can provide IDs or use simple incrementing ints
            HealthPractice(name: "Hand Hygiene", precautionType: standardPrecaution),
            HealthPractice(name: "PPE", precautionType: standardPrecaution),
            HealthPractice(name: "Airborne", precautionType: isolationPrecaution),
            HealthPractice(name: "Droplet", precautionType: isolationPrecaution),
            HealthPractice(name: "Contact", precautionType: isolationPrecaution),
            HealthPractice(name: "Contact Enteric", precautionType: isolationPrecaution)
        ]
    }
}
