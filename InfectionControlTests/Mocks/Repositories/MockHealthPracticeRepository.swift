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
    
    func populateList() {
        healthPracticeList = DataFactory.makeHealthPractices()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in HealthPractice Repository!")
    }
    
    func getHealthPracticeList() async throws -> [HealthPractice] {
        if let error = error {
            self.error = nil
            throw error
        }
        return healthPracticeList
    }
}
