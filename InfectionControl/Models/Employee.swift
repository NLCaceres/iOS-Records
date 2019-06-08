//
//  Employee.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

struct Employee: Codable {
    // Properties
    var id: String?
    var firstName: String
    var surname: String
    var profession: Profession?
    
//    init?(firstName: String, surname:String, profession:Profession) {
//        // Reasoning why I didn't check profession
//        // In theory: SWIFT OPTIONALS PREVENT NIL VALS FROM GETTING THRU WHERE THEY SHOULDN'T!
//        // In reality: That might not be true, but pretty sure it is
//        if (firstName.isEmpty || surname.isEmpty) {
//            return nil
//        }
//        self.firstName = firstName
//        self.surname = surname
//        self.profession = profession
//    }
    
    init(id: String? = nil, firstName: String, surname: String, profession: Profession? = nil) {
        self.id = id
        self.firstName = firstName
        self.surname = surname
        self.profession = profession
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case surname = "surname"
        case profession = "profession"
    }
    
    init(from decoder: Decoder) throws {
        let jsonKeys = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? jsonKeys.decode(String.self, forKey: .id)
        let firstName = try jsonKeys.decode(String.self, forKey: .firstName)
        let surname = try jsonKeys.decode(String.self, forKey: .surname)
        let profession = try? jsonKeys.decode(Profession.self, forKey: .profession)
        
        self.init(id: id, firstName: firstName, surname: surname, profession: profession)
    }
    
    func encode(to encoder: Encoder) throws {
        var jsonObj = encoder.container(keyedBy: CodingKeys.self)
        
        try? jsonObj.encode(id, forKey: .id)
        try jsonObj.encode(firstName, forKey: .firstName)
        try jsonObj.encode(surname, forKey: .surname)
        try? jsonObj.encode(profession, forKey: .profession)
    }
}
