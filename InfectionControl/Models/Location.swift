//
//  Location.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

struct Location: Codable {
    // Properties
    var id: String?
    var facilityName: String
    var unitNum: String
    var roomNum: String
    
    init(id:String? = nil, facilityName:String, unitNum:String, roomNum:String) {
        self.id = id
        self.facilityName = facilityName
        self.unitNum = unitNum
        self.roomNum = roomNum
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case facilityName = "facilityName"
        case unitNum = "unitNum"
        case roomNum = "roomNum"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let facilityName = try jsonKeys.decode(String.self, forKey: .facilityName)
        let unitNum = try jsonKeys.decode(String.self, forKey: .unitNum)
        let roomNum = try jsonKeys.decode(String.self, forKey: .roomNum)
        
        self.init(id: id, facilityName: facilityName, unitNum: unitNum, roomNum: roomNum)
    }
    
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try jsonObj.encode(facilityName, forKey: .facilityName)
        try jsonObj.encode(unitNum, forKey: .unitNum)
        try jsonObj.encode(roomNum, forKey: .roomNum)
    }
}
