//
//  HealthPractice.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

struct HealthPractice: Codable {
    // Properties
    var id: String?
    var name: String
    var precautionType: Precaution?
    
//    init?(name: String, image:UIImage, precautionType:Precaution) {
//        if (name.isEmpty) {
//            return nil
//        }
//        self.name = name
//        self.image = image
//        self.precautionType = precautionType
//    }
    
    // Memberwise init provided by struct not enough (should in theory fill with nil though...)
    init(id: String? = nil, name: String, precautionType: Precaution? = nil) {
        self.id = id
        self.name = name
        self.precautionType = precautionType
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case precautionType = "precautionType"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let name = try jsonKeys.decode(String.self, forKey: .name)
        let precautionType = try? jsonKeys.decode(Precaution.self, forKey: .precautionType)
        
        self.init(id: id, name: name, precautionType: precautionType)
    }
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try jsonObj.encode(name, forKey: .name)
        try? jsonObj.encode(precautionType, forKey: .precautionType)
    }
}
