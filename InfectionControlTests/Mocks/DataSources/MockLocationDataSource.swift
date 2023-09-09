//
//  MockLocationDataSource.swift
//  InfectionControlTests
//
//  Copyright © 2023 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

class MockLocationDataSource: LocationDataSource {
    var locationList: [Location] = []
    var error: Error? = nil
    var calledCount: [String: Int] = [:]
    
    func getLocationList() async -> Result<[Location], Error> {
        calledCount[#function, default: 0] += 1
        if let error = error {
            self.error = nil // Reset error, so no test pollution and accidental unexpected thrown errors
            return .failure(error)
        }
        return .success(locationList)
    }
    
    // By making this dataSource a class, no wasteful "mutating" funcs are needed! Modify the dataSource as much as needed!
    func populateList() {
        locationList = MockLocationDataSource.makeList()
    }
    func prepToThrow() {
        error = NSError()
    }
    
    static func makeList() -> [Location] {
        let usc = "USC"
        let hsc = "HSC"
        
        return [
            Location(facilityName: usc, unitNum: "2", roomNum: "213"),
            Location(facilityName: usc, unitNum: "4", roomNum: "202"),
            Location(facilityName: hsc, unitNum: "3", roomNum: "213"),
            Location(facilityName: hsc, unitNum: "3", roomNum: "321"),
            Location(facilityName: hsc, unitNum: "5", roomNum: "121"),
        ]
    }
}
