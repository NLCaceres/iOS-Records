//
//  PrecautionTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class PrecautionTests: XCTestCase {

    func testEquality() throws {
        let precautionOne = Precaution(name: "Foo")
        let precautionTwo = Precaution(name: "Foo")
        XCTAssert(precautionOne == precautionTwo)
        
        let precautionWithIdOne = Precaution(id: "id1", name: "Foo")
        let precautionWithIdTwo = Precaution(id: "id1", name: "Foo")
        XCTAssert(precautionWithIdOne == precautionWithIdTwo)
    }

}
