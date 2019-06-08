//
//  CreateReportViewModel.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/21/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import Foundation

class CreateReportViewModel {
    var reportPracticeType: String
    var healthPractices: [HealthPractice]
    var locations: [Location]
    
    // Data Endpoint
    //let healthPracticeEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/healthPractices")
    //let locationEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/locations")
    let mockHealthPracticeEndpoint: URL! = URL(string: "http://127.0.0.1:3000/api/healthpractices")
    let mockLocationEndpoint: URL! = URL(string: "http://127.0.0.1:3000/api/locations")
    let urlSession = URLSession(configuration: .default)
    
    init() {
        self.reportPracticeType = ""
        self.healthPractices = [HealthPractice]()
        self.locations = [Location]()
    }
    func decodeHealthPractices(data: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedHealthPractices = try jsonDecoder.decode([HealthPractice].self, from: data)
            for decodedHealthPractice in decodedHealthPractices {
                print("This is the decoded health practice \(decodedHealthPractice)")
                guard let precautionType = decodedHealthPractice.precautionType else {
                    print("Missing the precautionType for some reason")
                    return
                }
                healthPractices.append(decodedHealthPractice)
            }
            
            DispatchQueue.main.async {
                print("This is the number of rows in health practices that we should see: \(self.healthPractices.count)")
            }
            
        } catch {
            print("Error in decodeHealthPractices: \(error)")
        }
    }
    func decodeLocations(data: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedLocations = try jsonDecoder.decode([Location].self, from: data)
            for decodedLocation in decodedLocations {
                print("This is the decoded location \(decodedLocation)")
                locations.append(decodedLocation)
            }
            
            DispatchQueue.main.async {
                print("This is the number of rows in locations that we should see: \(self.locations.count)")
            }
            
        } catch {
            print("Error in decodeHealthPractices: \(error)")
        }
    }
    
}
