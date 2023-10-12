//
//  RepositoryGenericsTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class RepositoryGenericsTests: XCTestCase {
    func testOnSuccess() async throws {
        let someEntity = try! await getEntity { return .success(1) }
        XCTAssertEqual(someEntity, 1) // Should successfully get the expected data from the success case
    }
    func testOnFailure() async throws {
        let failureMessage = "Failed to get entity"
        let someThrowingClosure: () async -> Result<Int, Error> = { return .failure(MockError.description(failureMessage)) }
        
        // Instead of running the following with "try?" then asserting the return value is nil due to ".failure(error)"
        do {
            _ = try await getEntity(getData: someThrowingClosure)
            XCTFail("Unexpectedly got an entity") // Should NEVER reach here, so if we do, force a test fail
        }
        // This alternative method can be extra certain that our method is failing EXACTLY the way we expect
        // by catching the error thrown, and asserting the description matches our MockError's message
        catch {
            XCTAssertEqual(error.localizedDescription, failureMessage)
        }
    }
}
