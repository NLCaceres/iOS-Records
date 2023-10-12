//
//  MockHealthPracticeRepository.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockHealthPracticeRepository: HealthPracticeRepository {
    var healthPracticeList: [HealthPractice] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func populateList() {
        healthPracticeList = DataFactory.makeHealthPractices()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in HealthPractice Repository")
    }
    
    func getHealthPracticeList() async throws -> [HealthPractice] {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil
            throw error
        }
        return healthPracticeList
    }
}
