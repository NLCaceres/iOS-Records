//
//  AssertableData.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* Used classes rather structs to take advantage of ref types holding values across closures */
class AssertableData: Codable {
    var didChange: Bool
    init(didChange: Bool = false) {
        self.didChange = didChange
    }
    init(_ newChange: AssertableData) {
        self.didChange = newChange.didChange
    }
}

class AssertTimesCalled {
    var numTimes = 0
}
