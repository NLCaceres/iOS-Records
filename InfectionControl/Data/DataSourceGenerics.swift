//
//  DataSourceGenerics.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

func getBaseArray<T: BaseTypeConvertible & Decodable>(for subtype: T.Type, getAsyncDataResult: () async -> Result<Data?, Error>) async -> Result<[T.Base], Error> {
    let result = await getAsyncDataResult()
    return Result { try result.get()?.toBaseArray(of: subtype) ?? [] } // If Data returned is nil, then return empty array. Else preserve the error
}
func getBase<T: BaseTypeConvertible & Decodable>(for subtype: T.Type, getAsyncDataResult: () async -> Result<Data?, Error>) async -> Result<T.Base?, Error> {
    let result = await getAsyncDataResult()
    return Result { try result.get()?.toBase(of: subtype) } // Okay for nil to be returned BUT NOT if HTTPResponse threw an error
}
