//
//  GenericDtoFetch.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* Using Async/Await makes it much easier to come up with a very generic/reusable set of funcs
  Simply put: Provide the UrlPath + Type we expect back. NetworkManager can be substituted if needed
  NetworkManager returns Data optional. Guard against nil Data or return an empty array
  THEN there's 2 possibilities: We either want a single DTO or an array of said DTOs
     GET -> Take the data convert it to our DTO and then to our Base, ready for use in a view
     GetALL -> Take the data convert it to our [DTO] then map over it to get an array of the DTO's base model
*/

// TODO: Likely don't need these anymore
func fetchDTO<T>(endpointPath: String, for type: T.Type,
                networkManager: FetchingNetworkManager = NetworkManager()) async -> T.Base? where T: ToBase, T: Decodable {
    guard case .success(let .some(modelData)) = await networkManager.fetchTask(endpointPath: endpointPath)
    else { return nil }

    return modelData.toDTO(of: type)?.toBase()
}
func fetchDTOArr<T>(endpointPath: String, containing type: T.Type,
                    networkManager: FetchingNetworkManager = NetworkManager()) async -> [T.Base] where T: ToBase, T: Decodable  {
    guard case .success(let .some(modelData)) = await networkManager.fetchTask(endpointPath: endpointPath)
    else { return [] }

    // Be sure data successfuly decoded and non-nil array of HealthPracticeDTO
    guard let modelArr = modelData.toArray(containing: type)
    else { return [] }

    return modelArr.compactMap { $0.toBase() } // Prevent optionals inside the arr
}
