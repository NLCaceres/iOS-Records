//
//  MockPrecautionRepository.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockPrecautionRepository: PrecautionRepository {
    var precautionList: [Precaution] = []
    var error: Error? = nil
    
    func populateList() {
        precautionList = DataFactory.makePrecautions()
    }
    func prepToThrow(description: String? = nil) {
        error = MockError.description(description ?? "Error occurred in Precaution Repository!")
    }
    
    func getPrecautionList() async throws -> [Precaution] {
        if let error = error {
            self.error = nil
            throw error
        }
        return precautionList
    }
}
