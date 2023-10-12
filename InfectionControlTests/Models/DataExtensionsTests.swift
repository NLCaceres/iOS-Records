//
//  DataExtensionsTests.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

final class DataExtensionsTests: XCTestCase {
    func testDataConvertingIntoDTO() throws {
        // WHEN using Data of a basic Decodable type like String
        let basicEncodable = "Hello World"
        let basicData = basicEncodable.data(using: .utf8)!
        // THEN .toDTO() will try BUT fail to convert into JSON, returning nil
        XCTAssertNil(basicData.toDTO(of: String.self))
        
        // WHEN using Data properly formatted as JSON
        let basicEncodableJson = "{ \"name\": \"Hello World\" }"
        let basicJsonData = basicEncodableJson.data(using: .utf8)!
        // THEN .toDTO() will STILL NOT convert this into a String
        // since the decoder expects the class to have properties matching the keys of the JSON
        XCTAssertNil(basicJsonData.toDTO(of: String.self))
        
        // WHEN using Data of an actual DTO type
        let dtoEncodable = ProfessionDTO(observedOccupation: "Foo", serviceDiscipline: "Bar")
        let dtoData = dtoEncodable.toData()! // Uses defaultEncoder()
        let dtoDecoded = dtoData.toDTO(of: ProfessionDTO.self)!
        // THEN properties match after being decoded back into its original type
        XCTAssertEqual(dtoDecoded.observedOccupation, "Foo")
        XCTAssertEqual(dtoDecoded.serviceDiscipline, "Bar")
        
        // WHEN the Data is forced to decode into an incorrect type WITHOUT matching properties
        let badDecode = dtoData.toDTO(of: EmployeeDTO.self)
        // THEN a nil value is returned indicating an error occurred in the decode process
        XCTAssertNil(badDecode)
        
        // WHEN the Data is forced to decode into an incorrect type WITH matching property names
        let healthPracticeDTO = HealthPracticeDTO(name: "Faz", precautionType: PrecautionDTO(name: "Fiz"))
        let healthPracticeData = healthPracticeDTO.toData()! // Uses defaultEncoder()
        // THEN the conversion WORKS despite any unexpected key-val pairs since they're ignored
        let accidentalPrecaution = healthPracticeData.toDTO(of: PrecautionDTO.self)!
        XCTAssertEqual(accidentalPrecaution.name, "Faz")
        //! The accidental Precaution DOESN'T fill their "practices" despite originally being a HealthPractice
        XCTAssertNil(accidentalPrecaution.practices)
    }
    func testDataConvertingIntoBase() throws {
        // WHEN attempting to convert Data of a basic type like String
        let basicEncodable = "Hello World"
        let _ = basicEncodable.data(using: .utf8)!
        // THEN not allowed since does not conform to BaseTypeConvertible
        // basicData.toBase(of: String.self)
        
        // WHEN using Data of an actual DTO type
        let dtoEncodable = EmployeeDTO(firstName: "Fizz", surname: "Buzz")
        let dtoData = dtoEncodable.toData()! // Use defaultEncoder()
        let employeeDecoded = dtoData.toBase(of: EmployeeDTO.self)!
        // THEN properties match after being decoded into its Base Type
        XCTAssertEqual(employeeDecoded.firstName, "Fizz")
        XCTAssertEqual(employeeDecoded.surname, "Buzz")
        
        // WHEN the Data is forced to decode into an incorrect type WITHOUT matching properties
        let badDecode = dtoData.toDTO(of: HealthPracticeDTO.self)
        // THEN a nil value is returned indicating an error occurred in the decode process
        XCTAssertNil(badDecode)
        
        // WHEN the Data is forced to decode into an incorrect type WITH matching property names
        let precautionDTO = PrecautionDTO(name: "Boom", practices: [HealthPracticeDTO(name: "Bam")])
        let precautionData = precautionDTO.toData()! // Uses defaultEncoder()
        // THEN the conversion WORKS despite any unexpected key-val pairs since they're ignored
        let accidentalHealthPractice = precautionData.toDTO(of: HealthPracticeDTO.self)!
        XCTAssertEqual(accidentalHealthPractice.name, "Boom")
        //! The accidental HealthPractice DOESN'T fill their "precautionType" despite originally being a Precaution
        XCTAssertNil(accidentalHealthPractice.precautionType)
    }
    
    func testDecodeToArray() throws {
        // WHEN using Array Data of a basic Decodable type like String
        let basicEncodableArray = ["Hello", "World"]
        let basicArrayData = basicEncodableArray.toData()!
        // THEN .toDecodedArray() will still allow conversion of Data into the basic types
        let basicDecodedArray = basicArrayData.toDecodedArray(containing: String.self)
        XCTAssertEqual(basicDecodedArray, basicEncodableArray)
        XCTAssertEqual(basicDecodedArray, ["Hello", "World"])
        
        // WHEN using Data of an actual DTO type
        let healthPracticeDtoArray = [HealthPracticeDTO(name: "Foo"), HealthPracticeDTO(name: "Bar")]
        let healthPracticeArrayData = healthPracticeDtoArray.toData()! // Uses defaultEncoder()
        // THEN .toDecodedArray() will successfully decode an Array of DTOs, matching the original
        let decodedHealthPracticeDtoArray = healthPracticeArrayData.toDecodedArray(containing: HealthPracticeDTO.self)!
        XCTAssertEqual(decodedHealthPracticeDtoArray.count, 2)
        XCTAssertEqual(decodedHealthPracticeDtoArray[0].name, "Foo")
        XCTAssertEqual(decodedHealthPracticeDtoArray[1].name, "Bar")
        
        // WHEN the Data is forced to decode into an incorrect type WITHOUT matching property names
        let badDecodedArray = healthPracticeArrayData.toDecodedArray(containing: ReportDTO.self)
        // THEN nil is returned indicating either empty or malformed data was sent
        XCTAssertNil(badDecodedArray)
        
        // WHEN the Data is forced to decode into an incorrect type WITH matching property names
        let unexpectedlyDecodedArray = healthPracticeArrayData.toDecodedArray(containing: PrecautionDTO.self)!
        // THEN the conversion WILL unexpectedly work
        XCTAssertEqual(unexpectedlyDecodedArray.count, 2)
        
        // WHEN the Data is forced to decode into an incorrect type WITH extra property names
        let filledHealthPracticeDtoArray = [
            HealthPracticeDTO(name: "Faz", precautionType: PrecautionDTO(name: "Fiz")),
            HealthPracticeDTO(name: "Baz", precautionType: PrecautionDTO(name: "Biz"))
        ]
        let filledHealthPracticeArrayData = filledHealthPracticeDtoArray.toData()! // Uses defaultEncoder()
        // THEN the conversion WILL still work since the extra/unexpected key-val pairs are just ignored
        let accidentalPrecautionDtoArray = filledHealthPracticeArrayData.toDecodedArray(containing: PrecautionDTO.self)!
        XCTAssertEqual(accidentalPrecautionDtoArray.count, 2)
        XCTAssertEqual(accidentalPrecautionDtoArray[0].name, "Faz")
        XCTAssertEqual(accidentalPrecautionDtoArray[1].name, "Baz")
        //! The accidental Precautions DON'T fill their "practices" despite originally being a HealthPractice
        XCTAssertNil(accidentalPrecautionDtoArray[0].practices)
        XCTAssertNil(accidentalPrecautionDtoArray[1].practices)
    }
    func testDecodeToBaseArray() throws {
        // WHEN using Array Data of a basic Decodable type like String
        let basicEncodableArray = ["Hello", "World"]
        let _ = basicEncodableArray.toData()!
        // THEN not allowed since does not conform to BaseTypeConvertible
        // basicArrayData.toBaseArray(of: String.self)
        
        // WHEN using Data of an actual DTO type
        let precautionDtoArray = [PrecautionDTO(name: "Faz"), PrecautionDTO(name: "Baz")]
        let precautionArrayData = precautionDtoArray.toData()! // Uses defaultEncoder()
        // THEN .toBaseArray() will return a matching array filled with its Base Type
        let decodedPrecautionArray = precautionArrayData.toBaseArray(of: PrecautionDTO.self)
        XCTAssertEqual(decodedPrecautionArray.count, 2)
        XCTAssertEqual(decodedPrecautionArray[0].name, "Faz")
        XCTAssertEqual(decodedPrecautionArray[1].name, "Baz")
        
        // WHEN the Data is forced to decode into an incorrect type WITHOUT matching property names
        let badDecodedArray = precautionArrayData.toBaseArray(of: ReportDTO.self)
        // THEN an empty array is returned indicating either empty or malformed data was sent
        XCTAssertEqual(badDecodedArray.count, 0)
        
        // WHEN the Data is forced to decode into an incorrect type WITH matching property names
        let unexpectedlyDecodedArray = precautionArrayData.toBaseArray(of: HealthPracticeDTO.self)
        // THEN the decode + conversion WILL unexpectedly work
        XCTAssertEqual(unexpectedlyDecodedArray.count, 2)
        
        // WHEN the Data is forced to decode into an incorrect type WITH extra property names
        let filledPrecautionDtoArray = [
            PrecautionDTO(name: "Boom", practices: [HealthPracticeDTO(name: "Bam")]),
            PrecautionDTO(name: "Fim", practices: [HealthPracticeDTO(name: "Fam")])
        ]
        let filledPrecautionArrayData = filledPrecautionDtoArray.toData()! // Uses defaultEncoder()
        // THEN the decode + conversion STILL WORKS since the extra/unexpected key-val pairs are just ignored
        let accidentalHealthPracticeArray = filledPrecautionArrayData.toBaseArray(of: HealthPracticeDTO.self)
        XCTAssertEqual(accidentalHealthPracticeArray.count, 2)
        XCTAssertEqual(accidentalHealthPracticeArray[0].name, "Boom")
        XCTAssertEqual(accidentalHealthPracticeArray[1].name, "Fim")
        //! The accidental HealthPractices DON'T fill their "precautionType" despite originally being a Precaution
        XCTAssertNil(accidentalHealthPracticeArray[0].precautionType)
        XCTAssertNil(accidentalHealthPracticeArray[1].precautionType)
    }
}
