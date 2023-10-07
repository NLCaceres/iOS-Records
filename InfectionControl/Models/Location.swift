//
//  Location.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Location: Equatable, Identifiable {
    // MARK: Properties
    var id: String?
    var facilityName: String
    var unitNum: String
    var roomNum: String
    var description: String { "Location: \(facilityName) Unit \(unitNum) Room \(roomNum)" }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.facilityName == rhs.facilityName && lhs.unitNum == rhs.unitNum && lhs.roomNum == rhs.roomNum
    }
}

// Data Transfer Objects rarely inherit from the basic version of the model
struct LocationDTO {
    var id: String?
    var facilityName: String
    var unitNum: String
    var roomNum: String
}

extension LocationDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id, facilityName, unitNum, roomNum
    }
    
    init(from base: Location) {
        self.init(id: base.id, facilityName: base.facilityName, unitNum: base.unitNum, roomNum: base.roomNum)
    }
}

extension LocationDTO: BaseTypeConvertible {
    func toBase() -> Location {
        Location(id: self.id, facilityName: self.facilityName, unitNum: self.unitNum, roomNum: self.roomNum)
    }
}
