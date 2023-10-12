//
//  DataExtensions.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

/* This Extension to the standard Data type helps to quickly and easily decode Data into my DTO model instances or DTO Arrays
 * Additionally, helper funcs are included to conveniently convert Data into DTOs and immediately into their Base types
 */

extension Data {
    // Converts Data into any Decodable type BUT expected to be used with my defaultDecoder to create instances of my DTO models
    func toDTO<T: Decodable>(of type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> T? {
        return try? decoder.decode(type.self, from: self)
    }
    // Converts Data into a DTO model via toDTO(), then into its Base type for the app to display
    func toBase<T: BaseTypeConvertible & Decodable>(of subtype: T.Type) -> T.Base? {
        return self.toDTO(of: subtype)?.toBase()
    }
    
    // Useful for decoding any array of Decodables, just like toDTO() but with decoding Arrays in mind
    // With [String] probably being the most common, an example would be "someData.toDecodedArray(containing: String.self)"
    // BUT it's currently only used as a convenient helper func in toBaseArray()
    func toDecodedArray<T: Decodable>(containing type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> [T]? {
        return try? decoder.decode([T].self, from: self) // Could reuse toDTO BUT this is a bit more clear what's happening
    }
    // Converts Data into a [DTO] via toDecodedArray(), then into a [Base] for display in-app
    func toBaseArray<T: BaseTypeConvertible & Decodable>(of subtype: T.Type) -> [T.Base] {
        guard let modelArr = self.toDecodedArray(containing: subtype) else { return [] }
        
        return modelArr.compactMap { $0.toBase() }
    }
}
