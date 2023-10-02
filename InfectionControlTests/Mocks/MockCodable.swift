//
//  MockCodable.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

/* Useful for causing Decoding or Encoding failures as well as providing a very simple DTO to observe */
struct MockCodable: Codable, ToBase {
    // Default encoder can't convert NaN or Infinity to JSON, so perfect for tripping guard statements that protect against failing encoding
    var testDouble: Double = .nan
    
    func toBase() -> MockCodable {
        return self
    }
}
