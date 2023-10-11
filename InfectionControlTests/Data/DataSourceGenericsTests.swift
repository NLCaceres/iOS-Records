//
//  DataSourceGenericsTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class DataSourceGenericsTests: XCTestCase {
    func testGetBase() async throws {
        let baseTypeConvertibleConformingType = ProfessionDTO.self
        
        // WHEN result is successful but the data is bad or nil
        let nilDataResult = await getBase(for: baseTypeConvertibleConformingType) { return .success(nil) }
        let nilSuccessResult = try? nilDataResult.get() // Access the success's return BUT due to invalid data,
        let nilProfession: Profession? = nil
        XCTAssertEqual(nilSuccessResult, nilProfession) // THEN receive nil Profession
        
        // WHEN result is successful with valid data
        let professionDTO = ProfessionDTO(from: Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo"))
        let professionData = professionDTO.toData()
        let validDataResult = await getBase(for: baseTypeConvertibleConformingType) { return .success(professionData) }
        let successResult = try! validDataResult.get() // Access the success's return
        let expectedProfession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssertEqual(successResult, expectedProfession) // THEN receive a result with valid matching Profession value
        
        // WHEN result is a failure from a thrown error
        let errorResult = await getBase(for: baseTypeConvertibleConformingType) { return .failure(MockError.description("getBase() failed")) }
        let failureResult = try? errorResult.get()
        XCTAssertNil(failureResult) // THEN the error thrown by get() finding .failure() results in a nil due to "try?"
    }
    func testGetBaseArray() async throws {
        let baseTypeConvertibleConformingType = EmployeeDTO.self
        
        // WHEN result is successful BUT data is bad or nil
        let nilDataResult = await getBaseArray(for: baseTypeConvertibleConformingType) { return .success(nil) }
        let nilSuccessResult = try? nilDataResult.get() // Access the success's return BUT due to invalid data,
        XCTAssertEqual(nilSuccessResult, []) // THEN receive an empty array
        
        // WHEN result is successful with valid data
        let employeeDtoArray = [EmployeeDTO(from: Employee(firstName: "John", surname: "Smith")),
                                EmployeeDTO(from: Employee(firstName: "Melody", surname: "Rios"))]
        let employeeDtoArrayData = employeeDtoArray.toData()
        let validDataResult = await getBaseArray(for: baseTypeConvertibleConformingType) { return .success(employeeDtoArrayData) }
        let successResult = try! validDataResult.get()
        let expectedEmployeeList = [Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Melody", surname: "Rios")]
        XCTAssertEqual(successResult, expectedEmployeeList) // THEN receive a result with a valid Array of Employees with matching names
        
        // WHEN result is failure from a thrown error
        let errorResult = await getBaseArray(for: baseTypeConvertibleConformingType) { return .failure(MockError.description("getBaseArray() failed")) }
        let failureResult = try? errorResult.get()
        XCTAssertNil(failureResult) // THEN the error thrown by get() finding .failure() results in a nil due to "try?"
    }
}
