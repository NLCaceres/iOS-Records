//
//  DataSourceGenerics.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

func getBaseArray<T: ToBase & Decodable>(for type: T.Type, fetchTask: () async -> Result<Data?, Error>) async -> Result<[T.Base], Error> {
    let result = await fetchTask()
    return Result { try result.get()?.toBaseArray(through: type) ?? [] } // If Data returned is nil, then return empty array. Else preserve the error
}
func getBase<T: ToBase & Decodable>(for type: T.Type, fetchTask: () async -> Result<Data?, Error>) async -> Result<T.Base?, Error> {
    let result = await fetchTask()
    return Result { try result.get()?.toBase(through: type) } // Okay for nil to be returned BUT NOT if HTTPResponse threw an error
}
