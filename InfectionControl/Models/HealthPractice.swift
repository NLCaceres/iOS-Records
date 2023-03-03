//
//  HealthPractice.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct HealthPractice: Equatable, Identifiable {
    // MARK: Properties
    var id: String?
    var name: String
    var precautionType: Precaution?
    
    static func == (lhs: HealthPractice, rhs: HealthPractice) -> Bool {
        return lhs.name == rhs.name && lhs.precautionType == rhs.precautionType
    }
}

struct HealthPracticeDTO {
    // MARK: Properties
    var id: String?
    var name: String
    var precautionType: PrecautionDTO?
}

extension HealthPracticeDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, precautionType
    }
    
    // Need overriden decoder init since precautionType sometimes get sent as a array of id strings
    init(from decoder: Decoder) throws { // Which would cause the decoder to fail if not customized as follows
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let name = try jsonKeys.decode(String.self, forKey: .name)
        let precautionType = try? jsonKeys.decode(PrecautionDTO.self, forKey: .precautionType)
        
        self.init(id: id, name: name, precautionType: precautionType)
    }
    
    init(from base: HealthPractice) {
        let precautionDTO = base.precautionType != nil ? PrecautionDTO(from: base.precautionType!) : nil
        self.init(id: base.id, name: base.name, precautionType: precautionDTO)
    }
}

extension HealthPracticeDTO: ToBase {
    func toBase() -> HealthPractice { // OK for precaution to be nil since API often returns stringID or [ID]
        let precautionType = self.precautionType?.toBase()
        return HealthPractice(id: self.id, name: self.name, precautionType: precautionType)
    }
}
