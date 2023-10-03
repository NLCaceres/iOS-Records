//
//  DataFactory.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

struct DataFactory {
    static func makeEmployees() -> [Employee] {
        return [ //? ID is important since it helps to be sure two employees are actually the same and don't just have the same name
            Employee(id: "0", firstName: "John", surname: "Smith",
                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
            Employee(id: "1", firstName: "Jill", surname: "Chambers",
                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
            Employee(id: "2", firstName: "Victor", surname: "Richards",
                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor")),
            Employee(id: "3", firstName: "Melody", surname: "Rios",
                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor")),
            Employee(id: "4", firstName: "Brian", surname: "Ishida",
                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor"))
        ]
    }
    static func makeHealthPractices() -> [HealthPractice] {
        let standardPrecaution = Precaution(name: "Standard")
        let isolationPrecaution = Precaution(name: "Isolation")
        
        return [ // All IDs are nil by default, if needed, but may need a version that can provide IDs or use simple incrementing ints
            HealthPractice(name: "Hand Hygiene", precautionType: standardPrecaution),
            HealthPractice(name: "PPE", precautionType: standardPrecaution),
            HealthPractice(name: "Airborne", precautionType: isolationPrecaution),
            HealthPractice(name: "Droplet", precautionType: isolationPrecaution),
            HealthPractice(name: "Contact", precautionType: isolationPrecaution),
            HealthPractice(name: "Contact Enteric", precautionType: isolationPrecaution)
        ]
    }
    static func makeLocations() -> [Location] {
        let usc = "USC"
        let hsc = "HSC"
        
        return [
            Location(facilityName: usc, unitNum: "2", roomNum: "213"),
            Location(facilityName: usc, unitNum: "4", roomNum: "202"),
            Location(facilityName: hsc, unitNum: "3", roomNum: "213"),
            Location(facilityName: hsc, unitNum: "3", roomNum: "321"),
            Location(facilityName: hsc, unitNum: "5", roomNum: "121"),
        ]
    }
    static func makePrecautions() -> [Precaution] {
        let healthPractices = makeHealthPractices()
        
        return [
            Precaution(name: "Standard", practices: Array(healthPractices[0..<2])), // Should grab "Hand Hygiene" and "PPE"
            Precaution(name: "Isolation", practices: Array(healthPractices[2...])) // This will grab "Airborne", "Droplet", "Contact", & "Contact Enteric"
        ]
    }
    static func makeReports() -> [Report] {
        let employeeList = makeEmployees()
        let healthPracticeList = makeHealthPractices()
        let locationList = makeLocations()
        
        let Iso8601DateFormatter = ISO8601DateFormatter() // May 19 2019 6:36AM
        let exampleDate = Iso8601DateFormatter.date(from: "2019-05-19T06:36:05Z")!
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateList = [
            exampleDate,
            gregorianCalendar.date(byAdding: .day, value: 1, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: 7, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: -5, to: exampleDate)!,
            gregorianCalendar.date(byAdding: .day, value: -27, to: exampleDate)!
        ]
        
        return [
            Report(id: "0", employee: employeeList[0], healthPractice: healthPracticeList[0], location: locationList[1], date: dateList[0]),
            Report(id: "1", employee: employeeList[1], healthPractice: healthPracticeList[4], location: locationList[3], date: dateList[1]),
            Report(id: "2", employee: employeeList[2], healthPractice: healthPracticeList[3], location: locationList[2], date: dateList[2]),
            Report(id: "3", employee: employeeList[3], healthPractice: healthPracticeList[0], location: locationList[4], date: dateList[3]),
            Report(id: "4", employee: employeeList[4], healthPractice: healthPracticeList[1], location: locationList[0], date: dateList[4]),
        ]
        // ID: 0,  John Smith, Clinic Nurse, Hand Hygiene - Standard, USC 4 202, May 19 2019
        // ID: 1,  Jill Chambers, Clinic Nurse, Contact - Isolation, HSC 3 321, May 20 2019
        // ID: 2,  Victor Richards, Clinic Doctor, Droplet - Isolation, HSC 3 213, May 26 2019
        // ID: 3,  Melody Rios, Clinic Doctor, Hand Hygiene - Standard, HSC 5 121, May 14 2019
        // ID: 4,  Brian Ishida, Clinic Doctor, PPE - Standard, USC 2 213, April 22 2019
    }
}
