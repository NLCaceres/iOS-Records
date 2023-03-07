//
//  RepositoryGenerics.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* Following consolidates a repository's common fetch request logic into a simple function returning the expected entity from the dataSource */
func getResult<T>(getData: () async -> Result<T, Error>) async throws -> T {
    let apiResult = await getData() // Call the apiDataSource
    
    switch apiResult { // Check API DataSource result
    case .success(let entity):
        return entity // Return the entity if the dataSource had no problems
    case .failure(let error): // Or else let the caller handle the error about to be thrown
        throw error
    }
    // TODO: Maybe next step in repository logic is to 1st check in CoreData to be sure no backup data?
    // TODO: If no backup in CoreData then throw an error to let viewModel render an error state to user
}
