//
//  Profession.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

// Important for building out a model vs Foundation
// which grabs everything
import UIKit

// MAY CHANGE TO STRUCT!! STRUCT COMES WITH INIT BAKED IN
struct Profession: Codable {
    // Properties
    var id: String?
    var observedOccupation: String
    var serviceDiscipline: String
    
    // This is possible with structs as well
    // Giving you free access to instantiate with optional parameters (zero params, one param, all params!)
//    init?(observedOccupation: String, serviceDiscipline: String) {
//        // Since the init method has the ? at the end of it
//        // It also could have had a ! to force it to always work (but you better make sure it always gets something then! not recommended)
//        // We can make optional professions (either return an object or nil without crashing)
//        // This if statement ensures it works as expected
//        if (observedOccupation.isEmpty || serviceDiscipline.isEmpty) {
//            return nil
//        }
//        self.observedOccupation = observedOccupation
//        self.serviceDiscipline = serviceDiscipline
//    }
    
    init(id: String? = nil, observedOccupation: String, serviceDiscipline: String) {
        self.id = id
        self.observedOccupation = observedOccupation
        self.serviceDiscipline = serviceDiscipline
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case observedOccupation = "observed_occupation"
        case serviceDiscipline = "service_discipline"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let observedOccupation = try jsonKeys.decode(String.self, forKey: .observedOccupation)
        let serviceDiscipline = try jsonKeys.decode(String.self, forKey: .serviceDiscipline)
        
        self.init(id: id, observedOccupation: observedOccupation, serviceDiscipline: serviceDiscipline)
    }
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try jsonObj.encode(observedOccupation, forKey: .observedOccupation)
        try jsonObj.encode(serviceDiscipline, forKey: .serviceDiscipline)
    }
    
}


// The following are examples of how to manually encode and decode
// Useful knowledge but mostly for very complicated JSON returns
// In this case, this is probably exactly what's running under the hood
//extension Profession: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(observedOccupation, forKey: .observedOccupation)
//        try container.encode(serviceDiscipline, forKey: .serviceDiscipline)
//    }
//}

//extension Profession: Decodable {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        observedOccupation = try values.decode(String.self, forKey: .observedOccupation)
//        serviceDiscipline = try values.decode(String.self, forKey: .serviceDiscipline)
//    }
//}


