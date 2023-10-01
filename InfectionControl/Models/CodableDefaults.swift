//
//  CodableDefaults.swift
//  InfectionControl
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

/* Provides a default Decoder and Encoder to use for JSON conversions
 * WHICH the following extension to Encodable uses to quickly and easily encode my model instances into Data
 * A CodingError enum is also provided that currently is thrown in cases where the defaultEncoder fails
 */

func defaultDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
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

// Since can't add cases to enums by "extension", such as the standard Swift EncodingError enum, have to make our own Coding errors!
enum CodingError: Error {
    case notEncodable
}
