//
//  JsonFactory.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

import Foundation

struct JsonFactory {
    // TODO: Maybe consider simple json file reading
    // MARK: Utility String Builders
    static func jsonStart() -> String { return "{\n" }
    static func jsonLine(_ key: String, to value: String, finalLine: Bool = false, indentLevel: Int = 0) -> String {
        let objOrArrCheck = value.hasPrefix("{") || value.hasPrefix("[")
        let valStr = objOrArrCheck ? "\(value)" : "\"\(value)\""
        let keyValStr = "\"\(key)\" : " + valStr
        
        let startIndentStr = String(repeating: "  ", count: indentLevel + 1)
        let newLineStr = objOrArrCheck && finalLine ? "\(startIndentStr)}\n" :
            objOrArrCheck ? "\(startIndentStr)},\n" : finalLine ? "\n" : ",\n"
        let thisJsonLine = startIndentStr + keyValStr + newLineStr
        return finalLine && indentLevel == 0 ? thisJsonLine + "}" : thisJsonLine
    }
    
    // MARK: Employees
    static private var createdEmployees = 0
    static var expectedEmployeeID: Int { return createdEmployees > 0 ? createdEmployees - 1 : 0 }
    static func EmployeeJSON(hasID: Bool = false, hasProfession: Bool = false, indentLevel: Int = 0) -> String {
        let firstNameLine = jsonLine("firstName", to: "name\(createdEmployees)", indentLevel: indentLevel)
        let idLine = hasID ? jsonLine("id", to: "employeeId\(createdEmployees)", indentLevel: indentLevel) : ""
        let professionLine = hasProfession ? jsonLine("profession", to: ProfessionJSON(indentLevel: indentLevel + 1)) : ""
        let surnameLine = jsonLine("surname", to: "surname\(createdEmployees)", finalLine: true, indentLevel: indentLevel)
        
        let employeeJSON = jsonStart() + firstNameLine + idLine + professionLine + surnameLine
        
        createdEmployees += 1
        return employeeJSON
    }
    // MARK: Professions
    static private var createdProfessions = 0
    static var expectedProfessionID: Int { return createdProfessions > 0 ? createdProfessions - 1 : 0 }
    static func ProfessionJSON(hasID: Bool = false, indentLevel: Int = 0) -> String {
        let occupationLine = jsonLine("observedOccupation", to: "occupation\(createdProfessions)", indentLevel: indentLevel)
        let idLine = jsonLine("id", to: "professionId\(createdProfessions)", indentLevel: indentLevel)
        let keyStartStr = hasID ? idLine + occupationLine : occupationLine
        let disciplineLine = jsonLine("serviceDiscipline", to: "discipline\(createdProfessions)", finalLine: true, indentLevel: indentLevel)
        
        let professionJSON = jsonStart() + keyStartStr + disciplineLine
        
        createdProfessions += 1
        return professionJSON
    }
    
    // MARK: HealthPractices
    static private var createdHealthPractices = 0
    static var expectedHealthPracticeID: Int { return createdHealthPractices > 0 ? createdHealthPractices - 1 : 0 }
    static func HealthPracticeJSON(hasID: Bool = false, hasPrecaution: Bool = false, indentLevel: Int = 0) -> String {
        let nameLine = jsonLine("name", to: "name\(createdHealthPractices)", finalLine: !hasPrecaution, indentLevel: indentLevel)
        let idLine = jsonLine("id", to: "healthPracticeId\(createdHealthPractices)", indentLevel: indentLevel)
        let keyStartStr = hasID ? idLine + nameLine : nameLine
        let precautionLine = hasPrecaution ? jsonLine("precaution", to: PrecautionJSON(indentLevel: 1), finalLine: true) : ""
        
        let healthPracticeJSON = jsonStart() + keyStartStr + precautionLine
        
        createdHealthPractices += 1
        return healthPracticeJSON
    }
    // MARK: Precautions
    static private var createdPrecautions = 0
    static var expectedPrecautionID: Int { return createdPrecautions > 0 ? createdPrecautions - 1 : 0 }
    static func PrecautionJSON(hasID: Bool = false, numPractices: Int = 0, indentLevel: Int = 0) -> String {
        let nameLine = jsonLine("name", to: "name\(createdPrecautions)", finalLine: true, indentLevel: indentLevel) // ALWAYS is last but ALWAYS there
        let idLine = jsonLine("id", to: "precautionId\(createdPrecautions)", indentLevel: indentLevel)
        let healthPractices = numPractices > 0 ? jsonLine("healthPractices", to: HealthPracticeJSON()) : ""
        let keySet = hasID ? idLine + healthPractices + nameLine :
            (numPractices > 0) ? healthPractices + nameLine : nameLine
        
        let precautionJSON = jsonStart() + keySet

        createdPrecautions += 1
        return precautionJSON
    }
    
    // MARK: Locations
    static private var createdLocations = 0
    static var expectedLocationID: Int { return createdLocations > 0 ? createdLocations - 1 : 0 }
    static func LocationJSON(hasID: Bool = false) -> String {
        let facilityNameLine = jsonLine("facilityName", to: "facility\(createdLocations)")
        let idLine = hasID ? jsonLine("id", to: "locationId\(createdLocations)") : ""
        let roomLine = jsonLine("roomNum", to: "room\(createdLocations)")
        let unitLine = jsonLine("unitNum", to: "unit\(createdLocations)", finalLine: true)
        
        let locationJSON = jsonStart() + facilityNameLine + idLine + roomLine + unitLine
        
        createdLocations += 1
        return locationJSON
    }
    static func LocationJSONData(hasID: Bool = false) -> Data {
        LocationJSON(hasID: hasID).data(using: .utf8)!
    }
    
    // MARK: Reports
    static private var createdReports = 0
    static var expectedReportID: Int { return createdReports > 0 ? createdReports - 1 : 0 }
    static func ReportJSON(hasID: Bool = false) -> String {
        let reportJSON = ""
        // TODO: If report JSON needed, likely a similar solution to Precaution handling HealthPracticeJSON()
        createdReports += 1
        return reportJSON
    }
}
