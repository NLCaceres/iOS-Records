//
//  HealthPracticeRepository.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol HealthPracticeRepository {
    func getHealthPracticeList() async throws -> [HealthPractice]
}

struct AppHealthPracticeRepository: HealthPracticeRepository {
    let healthPracticeApiDataSource: HealthPracticeDataSource
    let healthPracticeCoreDataSource: HealthPracticeDataSource
    
    init(healthPracticeApiDataSource: HealthPracticeDataSource = HealthPracticeApiDataSource(),
         healthPracticeCoreDataSource: HealthPracticeDataSource = HealthPracticeCoreDataSource()) {
        self.healthPracticeApiDataSource = healthPracticeApiDataSource
        self.healthPracticeCoreDataSource = healthPracticeCoreDataSource
    }
    
    func getHealthPracticeList() async throws -> [HealthPractice] {
        return try await getEntity { await healthPracticeApiDataSource.getHealthPracticeList() }
    }
}
