//
//  Report.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Report: Equatable, Identifiable {
    var id: String?
    var employee: Employee
    var healthPractice: HealthPractice
    var location: Location
    var date: Date
    
    static func ==(lhs: Report, rhs: Report) -> Bool {
        return lhs.id == rhs.id && lhs.employee == rhs.employee && lhs.healthPractice == rhs.healthPractice &&
            lhs.location == rhs.location && lhs.date.description == rhs.date.description
    } // TODO: It's possible Swift's date ==() function is too accurate causing a floating-point precision style issue
    // Where left-date is "2023-03-06 20:30:45 +0000" vs right-date "2023-03-06 20:30:45 +0000" BUT under the hood
    // The right side's time is actually "20:30:45.0023" and therefore not truly equal
    // Description correctly compares the dates to a more reasonable precision BUT Calendar may be better in the long run
    
    // LangCodes to consider "en" == "Month/Day/Year"
    // "es" + "fr" + "de" + "it" == "Day/Month/Year"
    // "ko" + "ja" + "zh" == "Year/Month/Day"
    static func dateHelper(_ date: Date, long: Bool = false, langCode: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: langCode ?? Locale.current.language.minimalIdentifier) // Easier to test thanks to default param
        //? Most BCP-47 / IETF language tags are simple language+region subtags, while some will append a script subtag, like for Cyrillic langs
        //? .minimalIdentifier USUALLY drops the region+script, leaving pretty much exactly what I want, the language subtag
        //? Since MOST language subtags are only 2 chars AND always come 1st, using someString.hasPrefix() should work well!
        
        if long && dateFormatter.locale.identifier.hasPrefix("en") {
            dateFormatter.dateFormat = "MMM d, yyyy. h:mm a."
        }
        else if long { // Long format, NON english
            dateFormatter.dateFormat = "d MMM yyyy H:mm"
        }
        else if dateFormatter.locale.identifier.hasPrefix("en") { // Short format, english
            dateFormatter.dateFormat = "M/d/yy"
        }
        else { // Short format, NON english
            dateFormatter.dateFormat = "d/M/yy"
        }

        return dateFormatter.string(from: date)
    }
}

struct ReportDTO {
    var id: String?
    var employee: EmployeeDTO?
    var healthPractice: HealthPracticeDTO?
    var location: LocationDTO?
    var date: Date
}

extension ReportDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case date = "date_reported", employee, id = "_id", healthPractice, location
    }
    
    init(from base: Report) {
        self.init(id: base.id, employee: EmployeeDTO(from: base.employee), healthPractice:
                    HealthPracticeDTO(from: base.healthPractice), location: LocationDTO(from: base.location), date: base.date)
    }
}

extension ReportDTO: ToBase {
    func toBase() -> Report? {
        guard let employee = self.employee?.toBase(), let healthPractice = self.healthPractice?.toBase(),
                let location = self.location?.toBase() else { return nil }
        return Report(id: self.id, employee: employee, healthPractice: healthPractice, location: location, date: self.date)
    }
}
