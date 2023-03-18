//
//  RepositoryGenericsTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class RepositoryGenericsTests: XCTestCase {
    func testOnSuccess() async throws {
        let someEntity = try? await getEntity { return .success(1) }
        XCTAssertEqual(someEntity, 1) // Should successfully get the expected data from the success case
    }
    func testOnFailure() async throws {
        let someThrowingClosure: () async -> Result<Int, Error> = { return .failure(NSError()) }
        let someResult = try? await getEntity(getData: someThrowingClosure)
        XCTAssertNil(someResult) // Error should have been thrown so nil gets returned by getEntity
    }
}
