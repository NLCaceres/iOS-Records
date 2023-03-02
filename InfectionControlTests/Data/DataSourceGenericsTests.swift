//
//  DataSourceGenericsTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class DataSourceGenericsTests: XCTestCase {
    func testGetBase() async throws {
        let toBaseDecodableType = ProfessionDTO.self
        
        // SUCCESSFUL RESULT BUT BAD DATA
        let nilDataResult = await getBase(for: toBaseDecodableType) { return .success(nil) }
        let nilSuccessResult = try? nilDataResult.get() // Access the success return  BUT it's nil due to invalid data
        let nilProfession: Profession? = nil
        XCTAssertEqual(nilSuccessResult, nilProfession) // If result is successful BUT data nil THEN receive nil
        
        // SUCCESSFUL RESULT WITH VALID DATA
        let professionDTO = ProfessionDTO(from: Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo"))
        let professionData = professionDTO.toData()
        let validDataResult = await getBase(for: toBaseDecodableType) { return .success(professionData) }
        let successResult = try? validDataResult.get() // Access the success return and receive its valid Profession value!
        let profession = Profession(observedOccupation: "Foobar", serviceDiscipline: "Barfoo")
        XCTAssertEqual(successResult, profession) // If result is successful BUT nil THEN receive a result with an empty array
        
        // FAILURE RESULT FROM THROWN ERROR
        let errorResult = await getBase(for: toBaseDecodableType) { return .failure(NSError()) }
        let failureResult = try? errorResult.get() // Should throw, resulting in another nil return
        XCTAssertEqual(failureResult, nil) // If result is successful BUT nil THEN receive a result with an empty array
    }
    func testGetBaseArray() async throws {
        let toBaseDecodableType = EmployeeDTO.self
        
        // SUCCESSFUL RESULT BUT BAD DATA
        let nilDataResult = await getBase(for: toBaseDecodableType) { return .success(nil) }
        let nilSuccessResult = try? nilDataResult.get() // Access the success return  BUT it's nil due to invalid data
        let nilEmployee: Employee? = nil
        XCTAssertEqual(nilSuccessResult, nilEmployee) // If result is successful BUT data nil THEN receive nil
        
        // SUCCESSFUL RESULT WITH VALID DATA of ARRAY
        let employeeDtoArray = [EmployeeDTO(from: Employee(firstName: "John", surname: "Smith")), EmployeeDTO(from: Employee(firstName: "Melody", surname: "Rios"))]
        let jsonEncoder = JSONEncoder()
        let employeeDtoArrayData = try? jsonEncoder.encode(employeeDtoArray)
        let validDataResult = await getBaseArray(for: toBaseDecodableType) { return .success(employeeDtoArrayData) }
        let successResult = try? validDataResult.get()
        let employee = [Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Melody", surname: "Rios")]
        XCTAssertEqual(successResult, employee) // If result is successful BUT nil THEN receive a result with an empty array
        
        // FAILURE RESULT FROM THROWN ERROR
        let errorResult = await getBase(for: toBaseDecodableType) { return .failure(NSError()) }
        let failureResult = try? errorResult.get() // Should throw, resulting in another nil return
        XCTAssertEqual(failureResult, nil) // If result is successful BUT nil THEN receive a result with an empty array
    }
}
