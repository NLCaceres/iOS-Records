//
//  Employee.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

// Identifiable just requires an id prop which works fine thanks to mongoDB UUIDs '_id'
struct Employee: Equatable, Identifiable {
    // MARK: Properties
    var id: String?
    var firstName: String
    var surname: String
    var profession: Profession?
    var fullName: String { "\(firstName) \(surname)" }

    static func ==(lhs: Employee, rhs: Employee) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.surname == rhs.surname && lhs.profession == rhs.profession
    }
}

struct EmployeeDTO {
    // MARK: Properties
    var id: String?
    var firstName: String
    var surname: String
    var profession: ProfessionDTO?
}

extension EmployeeDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id, firstName, surname, profession
    }
    // TODO: Double check if this init decoder still needed since String/[String] issue should be resolved
    // Profession key gets sent a string or [string] so need to override unfortunately
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)

        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let firstName = try jsonKeys.decode(String.self, forKey: .firstName)
        let surname = try jsonKeys.decode(String.self, forKey: .surname)
        let profession = try? jsonKeys.decode(ProfessionDTO.self, forKey: .profession)

        self.init(id: id, firstName: firstName, surname: surname, profession: profession)
    }
    
    init(from base: Employee) {
        let professionDTO = base.profession != nil ? ProfessionDTO(from: base.profession!) : nil
        self.init(id: base.id, firstName: base.firstName, surname: base.surname, profession: professionDTO)
    }
}

extension EmployeeDTO: ToBase {
    func toBase() -> Employee {
        let profession = self.profession?.toBase() // Profession is often a stringID in reportsList so nil is OK
        return Employee(id: self.id, firstName: self.firstName, surname: self.surname, profession: profession)
    }
}
