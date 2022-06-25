//
//  Profession.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Profession: Equatable {
    // MARK: Properties
    var id: String?
    var observedOccupation: String
    var serviceDiscipline: String

    static func ==(lhs: Profession, rhs: Profession) -> Bool {
        return lhs.observedOccupation == rhs.observedOccupation && lhs.serviceDiscipline == rhs.serviceDiscipline
    }
}

struct ProfessionDTO {
    var id: String?
    var observedOccupation: String
    var serviceDiscipline: String
}

extension ProfessionDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case observedOccupation = "observed_occupation"
        case serviceDiscipline = "service_discipline"
    }
    
    init(from base: Profession) {
        self.init(id: base.id, observedOccupation: base.observedOccupation, serviceDiscipline: base.serviceDiscipline)
    }
}

extension ProfessionDTO: ToBase {
    func toBase() -> Profession {
        return Profession(id: self.id, observedOccupation: self.observedOccupation, serviceDiscipline: self.serviceDiscipline)
    }
}
