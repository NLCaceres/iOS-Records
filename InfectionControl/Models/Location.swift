//
//  Location.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

struct Location: Equatable {
    // Properties
    var id: String?
    var facilityName: String
    var unitNum: String
    var roomNum: String
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.facilityName == lhs.facilityName && lhs.unitNum == rhs.unitNum && lhs.roomNum == rhs.roomNum
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
        case id = "_id", facilityName, unitNum, roomNum
    } // Only need a raw value string for id, rest get coded just fine
    
    init(from base: Location) {
        self.init(id: base.id, facilityName: base.facilityName, unitNum: base.unitNum, roomNum: base.roomNum)
    }
}

extension LocationDTO: ToBase {
    func toBase() -> Location {
        Location(id: self.id, facilityName: self.facilityName, unitNum: self.unitNum, roomNum: self.roomNum)
    }
}
