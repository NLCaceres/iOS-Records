//
//  Precaution.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

struct Precaution: Codable {
    var id: String?
    var name:String
    var practices: [HealthPractice]?
    
    init(id: String? = nil, name: String, practices: [HealthPractice]? = nil) {
        self.id = id
        self.name = name
        self.practices = practices
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case practices = "practices"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let name = try jsonKeys.decode(String.self, forKey: .name)
        let practices = try? jsonKeys.decode([HealthPractice].self, forKey: .practices)
        
        // Following is just regular method with included method labels
        self.init(id: id, name: name, practices: practices)
    }
    
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try jsonObj.encode(name, forKey: .name)
        try? jsonObj.encode(practices, forKey: .practices)
    }
}
