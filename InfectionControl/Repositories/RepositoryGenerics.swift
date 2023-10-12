//
//  RepositoryGenerics.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* Following consolidates a repository's common fetch request logic into a simple function returning the expected entity from the dataSource */
func getEntity<T>(getAsyncResult: () async -> Result<T, Error>) async throws -> T {
    let asyncResult = await getAsyncResult() // Grab a Result filled with the expected data from the source
    return try asyncResult.get() // If successful, the entity is returned. ELSE let the caller handle the thrown error
    // TODO: Maybe next step in repository logic is to 1st check in CoreData to be sure no backup data?
    // TODO: If no backup in CoreData then throw an error to let viewModel render an error state to user
}
