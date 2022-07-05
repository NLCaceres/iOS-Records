//
//  ModelsFactory.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

struct ModelsFactory {
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
    
    // MARK: Locations
    static private var createdLocations = 0
    static var expectedLocationID: Int { return createdLocations > 0 ? createdLocations - 1 : 0 }
    static func createLocation() -> Location {
        let location = Location(id: "locationId\(createdLocations)", facilityName: "facility\(createdLocations)",
                        unitNum: "unit\(createdLocations)", roomNum: "room\(createdLocations)")
        createdLocations += 1
        return location
    }
    static func LocationJSON(hasID: Bool = false) -> String {
        let firstPropLine = jsonLine("facilityName", to: "facility\(createdLocations)")
        // If JSON keys not inserted in ascending order, will NEVER match Encoder's [.prettyPrinted, .sortedKeys]
        let idLine = jsonLine("_id", to: "locationId\(createdLocations)")
        let keyStartStr = hasID ? idLine + firstPropLine : firstPropLine
        let locationJSON = jsonStart() + keyStartStr + jsonLine("roomNum", to: "room\(createdLocations)") +
        jsonLine("unitNum", to: "unit\(createdLocations)", finalLine: true)
        
        createdLocations += 1
        return locationJSON
    }
    static func LocationJSONData(hasID: Bool = false) -> Data {
        LocationJSON(hasID: hasID).data(using: .utf8)!
    }
    
    // MARK: Employees
    static private var createdEmployees = 0
    static var expectedEmployeeID: Int { return createdEmployees > 0 ? createdEmployees - 1 : 0 }
    static func createEmployee(hasProfession: Bool = false) -> Employee {
        let profession = hasProfession ? createProfession() : nil
        let employee = Employee(id: "employeeId\(createdEmployees)", firstName: "firstName\(createdEmployees)",
                                surname: "surname\(createdEmployees)", profession: profession)
        createdEmployees += 1
        return employee
    }
    static func EmployeeJSON(hasID: Bool = false, hasProfession: Bool = false, indentLevel: Int = 0) -> String {
        let firstPropLine = jsonLine("first_name", to: "name\(createdEmployees)", indentLevel: indentLevel)
        let keyStartStr = hasID ? jsonLine("_id", to: "employeeId\(createdEmployees)", indentLevel: indentLevel) + firstPropLine : firstPropLine
        let professionLine = hasProfession ? jsonLine("profession", to: ProfessionJSON(indentLevel: 1)) : ""
        let employeeJSON = jsonStart() + keyStartStr + professionLine + jsonLine("surname", to: "surname\(createdEmployees)", finalLine: true)
        
        createdEmployees += 1
        return employeeJSON
    }
    
    // MARK: HealthPractices
    static private var createdHealthPractices = 0
    static var expectedHealthPracticeID: Int { return createdHealthPractices > 0 ? createdHealthPractices - 1 : 0 }
    static func createHealthPractice(hasPrecaution: Bool = false) -> HealthPractice {
        let precaution = createPrecaution()
        let healthPractice = HealthPractice(id: "practiceId\(createdHealthPractices)",
                                            name: "name\(createdHealthPractices)", precautionType: precaution)
        createdHealthPractices += 1
        return healthPractice
    }
    static func HealthPracticeJSON(hasID: Bool = false, hasPrecaution: Bool = false, indentLevel: Int = 0) -> String {
        let firstPropLine = jsonLine("name", to: "name\(createdHealthPractices)", finalLine: !hasPrecaution, indentLevel: indentLevel)
        let idLine = jsonLine("_id", to: "healthPracticeId\(createdHealthPractices)", indentLevel: indentLevel)
        let keyStartStr = hasID ? idLine + firstPropLine : firstPropLine
        let precautionLine = hasPrecaution ? jsonLine("precautionType", to: PrecautionJSON(indentLevel: 1), finalLine: true) : ""
        let healthPracticeJSON = jsonStart() + keyStartStr + precautionLine
        
        createdHealthPractices += 1
        return healthPracticeJSON
    }
    
    // MARK: Precautions
    static private var createdPrecautions = 0
    static var expectedPrecautionID: Int { return createdPrecautions > 0 ? createdPrecautions - 1 : 0 }
    static func createPrecaution(practicesNum: Int = 0) -> Precaution {
        let practices: [HealthPractice]? = practicesNum == 0 ? nil : nil
        let precaution = Precaution(id: "precautionId\(createdPrecautions)", name: "name\(createdPrecautions)", practices: practices)
        createdPrecautions += 1
        return precaution
    }
    static func PrecautionJSON(hasID: Bool = false, numPractices: Int = 0, indentLevel: Int = 0) -> String {
        let firstPropLine = jsonLine("name", to: "name\(createdPrecautions)", finalLine: true, indentLevel: indentLevel) // ALWAYS is last but ALWAYS there
        let idLine = jsonLine("_id", to: "precautionId\(createdPrecautions)", indentLevel: indentLevel)
        let healthPractices = numPractices > 0 ? jsonLine("healthPractices", to: HealthPracticeJSON()) : ""
        let keySet = hasID ? idLine + healthPractices + firstPropLine :
            (numPractices > 0) ? healthPractices + firstPropLine : firstPropLine
        let precautionJSON = jsonStart() + keySet

        createdPrecautions += 1
        return precautionJSON
    }
    
    // MARK: Professions
    static private var createdProfessions = 0
    static var expectedProfessionID: Int { return createdProfessions > 0 ? createdProfessions - 1 : 0 }
    static func createProfession() -> Profession {
        let profession = Profession(id: "professionId\(createdProfessions)", observedOccupation: "observedOccupation\(createdProfessions)",
                          serviceDiscipline: "serviceDiscipline\(createdProfessions)")
        createdProfessions += 1
        return profession
    }
    static func ProfessionJSON(hasID: Bool = false, indentLevel: Int = 0) -> String {
//        let endStr = String(repeating: "  ", count: indentLevel)
        let firstPropLine = jsonLine("observed_occupation", to: "occupation\(createdProfessions)", indentLevel: indentLevel)
        let idLine = jsonLine("_id", to: "professionId\(createdProfessions)", indentLevel: indentLevel)
        let keyStartStr = hasID ? idLine + firstPropLine : firstPropLine
        let disciplineLine = jsonLine("service_discipline", to: "discipline\(createdProfessions)", finalLine: true, indentLevel: indentLevel)
        let professionJSON = jsonStart() + keyStartStr + disciplineLine
        
        createdProfessions += 1
        return professionJSON
    }
    
    // MARK: Reports
    static private var createdReports = 0
    static var expectedReportID: Int { return createdReports > 0 ? createdReports - 1 : 0 }
    static func createReport() -> Report {
        let report = Report(id: "reportId\(createdReports)", employee: createEmployee(),
                      healthPractice: createHealthPractice(), location: createLocation(), date: createMockDate())
        createdReports += 1
        return report
    }
    static func ReportJSON(hasID: Bool = false) -> String {
        let reportJSON = ""
        
        createdReports += 1
        return reportJSON
    }
    // Should be "Oct 01, 2020, 03:12PM" (Specific Timezone [PST] required or will default to machine's local tz)
    static func createMockDate() -> Date {
        return DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "PST"),
                              year: 2020, month: 10, day: 1, hour: 15, minute: 12).date!
    }
    static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
