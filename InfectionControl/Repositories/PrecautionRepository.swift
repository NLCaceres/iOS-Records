//
//  PrecautionRepository.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol PrecautionRepository {
    func getPrecautionList() async throws -> [Precaution]
}

struct AppPrecautionRepository: PrecautionRepository {
    let precautionApiDataSource: PrecautionDataSource
    let precautionCoreDataSource: PrecautionDataSource
    
    init(precautionApiDataSource: PrecautionDataSource = PrecautionApiDataSource(),
         precautionCoreDataSource: PrecautionDataSource = PrecautionCoreDataSource()) {
        self.precautionApiDataSource = precautionApiDataSource
        self.precautionCoreDataSource = precautionCoreDataSource
    }
    
    func getPrecautionList() async throws -> [Precaution] {
        return try await getEntity { await precautionApiDataSource.getPrecautionList() }
//        return [
//            Precaution(name: "Standard", practices: [
//                HealthPractice(name: "Hand Hygiene"),
//                HealthPractice(name: "PPE")
//            ]),
//            Precaution(name: "Isolation", practices: [
//                HealthPractice(name: "Airborne"),
//                HealthPractice(name: "Droplet"),
//                HealthPractice(name: "Contact"),
//                HealthPractice(name: "Contact Enteric")
//            ])
//        ]
    }
}
