//
//  DataSourceGenerics.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

func getBaseArray<T: ToBase & Decodable>(for type: T.Type, fetchTask: () async -> Result<Data?, Error>) async -> Result<[T.Base], Error> {
    let result = await fetchTask()
    
    switch result {
    case .success(let .some(data)):
        return .success(data.toBaseArray(through: type))
    case .success(.none):
        return .success([])
    case .failure(let error):
        return .failure(error)
    }
}
func getBase<T: ToBase & Decodable>(for type: T.Type, fetchTask: () async -> Result<Data?, Error>) async -> Result<T.Base?, Error> {
    let result = await fetchTask()
    
    switch result {
    case .success(let .some(data)):
        return .success(data.toBase(through: type))
    case .success(.none):
        return .success(nil)
    case .failure(let error):
        return .failure(error)
    }
}
