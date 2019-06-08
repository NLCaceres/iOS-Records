//
//  Report.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

struct Report: Codable {
    var id: String?
    var employee: Employee?
    var healthPractice: HealthPractice?
    var location: Location?
    var date: Date
    
    init(id: String? = nil, employee: Employee? = nil, healthPractice: HealthPractice? = nil, location: Location? = nil, date: Date) {
        self.id = id
        self.employee = employee
        self.healthPractice = healthPractice
        self.location = location
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case employee = "employee"
        case healthPractice = "healthPractice"
        case location = "location"
        case date = "date_reported"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let employee = try? jsonKeys.decode(Employee.self, forKey: .employee)
        let healthPractice = try? jsonKeys.decode(HealthPractice.self, forKey: .healthPractice)
        let location = try? jsonKeys.decode(Location.self, forKey: .location)
        let date = try jsonKeys.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formattedDate = dateFormatter.date(from: date)
        self.init(id: id, employee: employee, healthPractice: healthPractice, location: location, date: formattedDate!)
    }
    
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try? jsonObj.encode(employee, forKey: .employee)
        try? jsonObj.encode(healthPractice, forKey: .healthPractice)
        try? jsonObj.encode(location, forKey: .location)
        try jsonObj.encode(date, forKey: .date)
    }
    
    static func dateHelper(_ date: Date) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.languageCode!)
        print("This is the language code: \(dateFormatter.locale.languageCode!)")
        if dateFormatter.locale.languageCode == "en" {
            dateFormatter.dateFormat = "MMM d, yyyy. h:mm a."
        } else {
            dateFormatter.dateFormat = "d MMM yyyy H:mm"
        }
        print("This is what we have from dateHelper: \(dateFormatter.string(from: date))")
    }
}
