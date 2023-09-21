//
//  ToFromDataProtocol.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

/* Goal: Simplify use of Codable Protocol with Data and Codable Instances AND to make the code declarative/readable
 1. ToBase defines relationship between DTO and its base model
 2. Extension in Data lets Data quickly and easily be decoded into DTO model instances or [DTO]
      Bonus: Define a default decoder + encoder to easily parse Mongo's Date format
 3. Extension in Encodable allows all encodable model instances to quickly be encoded in Data
 Bonus: BOTH extensions use our decoder/encoder as a default param that can be swapped as needed!
 */

protocol ToBase {
    associatedtype Base // Refers to the conforming class's normal base model (as opposed to a DTO)
    func toBase() -> Base
}

func defaultDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
}
extension Data {
    func toDTO<T: Decodable>(of type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> T? {
        return try? decoder.decode(type.self, from: self)
    }
    func toBase<T: ToBase & Decodable>(through type: T.Type) -> T.Base? {
        return self.toDTO(of: type)?.toBase()
    }
    
    func toArray<T: Decodable>(containing type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> [T]? {
        return try? decoder.decode([T].self, from: self) // Could reuse toDTO BUT this is a bit more clear what's happening
    }
    func toBaseArray<T: ToBase & Decodable>(through type: T.Type)  -> [T.Base] {
        guard let modelArr = self.toArray(containing: type) else { return [] }
        
        return modelArr.compactMap { $0.toBase() }
    }
}

func defaultEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    return encoder
}
extension Encodable {
    func toData(using encoder: JSONEncoder = defaultEncoder()) -> Data? {
        return try? encoder.encode(self)
    }
}
enum CodingError: Error { // Since can't add cases to enums by "extension", in this case the standard Swift EncodingError enum, make our own Coding errors!
    case notEncodable
}
