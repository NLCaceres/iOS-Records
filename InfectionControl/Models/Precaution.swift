//
//  Precaution.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Precaution: Equatable, Identifiable {
    var id: String?
    var name: String
    var practices: [HealthPractice]? // Might not receive the HealthPractices
    
    static func == (lhs: Precaution, rhs: Precaution) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.practices == rhs.practices
    }
}

struct PrecautionDTO {
    var id: String?
    var name: String
    var practices: [HealthPracticeDTO]?
}

extension PrecautionDTO: Codable {
    // Unlike HealthPracticeDTO, don't get an "expected string BUT got array" issue while decoding since "practices" key is usually an array of stringIDs
    enum CodingKeys: String, CodingKey {
        case id, name, practices = "healthPractices"
    }
    
    init(from base: Precaution) {
        if let practices = base.practices, practices.count > 0 {
            let practicesDTO = practices.map { HealthPracticeDTO(from: $0) }
            self.init(id: base.id, name: base.name, practices: practicesDTO)
        }
        else { self.init(id: base.id, name: base.name) }
    }
}

extension PrecautionDTO: BaseTypeConvertible {
    func toBase() -> Precaution {
        let practices = self.practices?.map { $0.toBase() }
        return Precaution(id: self.id, name: self.name, practices: practices)
    }
}
