//
//  MockError.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

/* Convenient way to throw errors in tests with a helpful description to check for
* BUT not perfect since in some cases, like URLProtocol, Swift under the hood will cast your error to another type of error
* like NSURLError, which will drop the description. Consequently, implementing LocalizedError may work even better! */
enum MockError: Error {
    case description(String)
}
