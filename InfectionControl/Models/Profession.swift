//
//  Profession.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Profession: Equatable, Identifiable {
    // MARK: Properties
    var id: String?
    var observedOccupation: String
    var serviceDiscipline: String
    var description: String { "\(observedOccupation) \(serviceDiscipline)" }

    static func ==(lhs: Profession, rhs: Profession) -> Bool {
        return lhs.observedOccupation == rhs.observedOccupation && lhs.serviceDiscipline == rhs.serviceDiscipline
    }
}

struct ProfessionDTO {
    // MARK: Properties
    var id: String?
    var observedOccupation: String
    var serviceDiscipline: String
}

extension ProfessionDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id // Alternatively can write all cases on a single line like the other models
        case observedOccupation
        case serviceDiscipline
    }
    
    init(from base: Profession) {
        self.init(id: base.id, observedOccupation: base.observedOccupation, serviceDiscipline: base.serviceDiscipline)
    }
}

extension ProfessionDTO: BaseTypeConvertible {
    func toBase() -> Profession {
        return Profession(id: self.id, observedOccupation: self.observedOccupation, serviceDiscipline: self.serviceDiscipline)
    }
}
