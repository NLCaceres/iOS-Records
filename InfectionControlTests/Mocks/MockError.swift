//
//  MockError.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

/* Convenient way to throw errors in tests with a helpful description to check for
* BUT not perfect since in some cases, like URLProtocol, Swift under the hood will cast your error to another type of error
* like NSURLError, which can drop the description */
enum MockError: LocalizedError {
    case description(String)
    var errorDescription: String? {
        switch self {
        case let .description(message): // Alternatively access the associated value as "case .description(let message)"
            return message
        }
    }
}
