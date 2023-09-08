//
//  HealthPracticeDataSource.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

protocol HealthPracticeDataSource {
    func getHealthPracticeList() async -> Result<[HealthPractice], Error>
}

/* For fetching from CoreData */
struct HealthPracticeCoreDataSource: HealthPracticeDataSource {
    func getHealthPracticeList() async -> Result<[HealthPractice], Error> {
        print("Get the HealthPractice List from CoreData")
        return .success([])
    }
}

/* Fetch from the API backend */
struct HealthPracticeApiDataSource: HealthPracticeDataSource {
    let networkManager: FetchingNetworkManager
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getHealthPracticeList() async -> Result<[HealthPractice], Error> {
        return await getBaseArray(for: HealthPracticeDTO.self) { await networkManager.fetchTask(endpointPath: "/healthPractices") }
    }
}
