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
    //? Most BCP-47 / IETF language tags are simple language+region subtags, while some will append a script subtag, like for Cyrillic langs
    //? locale.language.minimalIdentifier USUALLY drops the region+script so it's also a good option to get what I want -> the language subtag
    var localDate: String {
        let localeID = Report.dateFormatter.locale.identifier
        if Report.MDYLangs.contains(where: { localeID.hasPrefix($0) }) { // "en" == "Month/Day/Year"
            Report.dateFormatter.dateFormat = "M/d/yy"
        }
        else if Report.YMDLangs.contains(where: { localeID.hasPrefix($0) }) { // "ko" + "ja" + "zh" == "Year/Month/Day"
            Report.dateFormatter.dateFormat = "yy/M/d"
        }
        else { // "es" + "fr" + "de" + "it" == "Day/Month/Year" - Seemingly most common worldwide
            Report.dateFormatter.dateFormat = "d/M/yy"
        }
        return Report.dateFormatter.string(from: date)
    }
    var localDateTime: String {
        let localeID = Report.dateFormatter.locale.identifier
        if Report.MDYLangs.contains(where: { localeID.hasPrefix($0) }) { // "en"
            Report.dateFormatter.dateFormat = "MMM d, yyyy. h:mm a."
        }
        else if Report.YMDLangs.contains(where: { localeID.hasPrefix($0) }) { // "ko" + "ja" + "zh"
            Report.dateFormatter.dateFormat = "yyyy MMM d H:mm"
        }
        else { // "es" + "fr" + "de" + "it"
            Report.dateFormatter.dateFormat = "d MMM yyyy H:mm"
        }
        return Report.dateFormatter.string(from: date)  // Need to prefix static vars with class name
    }

    static var dateFormatter = DateFormatter() // By default, it should correctly grab the system Locale ("en_US" usually)
    static let YMDLangs = ["ko", "ja", "zh"]
    static let DMYLangs = ["es", "fr", "de", "it"]
    static let MDYLangs = ["en"]
    
    static func ==(lhs: Report, rhs: Report) -> Bool {
        return lhs.id == rhs.id && lhs.employee == rhs.employee && lhs.healthPractice == rhs.healthPractice &&
            lhs.location == rhs.location && lhs.date.description == rhs.date.description
    } // TODO: It's possible Swift's date ==() function is too accurate causing a floating-point precision style issue
    // Where left-date is "2023-03-06 20:30:45 +0000" vs right-date "2023-03-06 20:30:45 +0000" BUT under the hood
    // The right side's time is actually "20:30:45.0023" and therefore not truly equal
    // Alternatively, the dates can be thought of as seconds since 1970
    // Where date1 is "123456.123456" since 1970 and date2 after encoding/decoding is "123456.12345678" causing a slight difference and false equality
    // Description correctly compares the dates to a more reasonable precision BUT Calendar may be better in the long run
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
