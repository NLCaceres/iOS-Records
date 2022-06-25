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
    func toDTO<T>(of type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> T? where T: Decodable {
        return try? decoder.decode(type.self, from: self)
    }
    func toArray<T>(containing type: T.Type, using decoder: JSONDecoder = defaultDecoder()) -> [T]? where T: Decodable {
        return try? decoder.decode([T].self, from: self) // Could reuse toDTO BUT this is a bit more clear what's happening
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
