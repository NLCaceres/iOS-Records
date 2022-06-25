//
//  ReportTableCellViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import UIKit

class ReportTableCellViewModel: NSObject {
    
    // MARK: Properties
    private(set) var report: Report
    
    // MARK: READ-Only Computed Props
    var image: UIImage { //TODO: Need to add specific imgs for each report type
        var tempImg = #imageLiteral(resourceName: "report_placeholder_icon")
        switch self.report.healthPractice.name {
        case "Hand Hygiene":
            print("Going to update to hand hygiene image")
        case "PPE":
            tempImg = #imageLiteral(resourceName: "mask")
        case "Contact":
            print("Going to update to contact")
        case "Droplet":
            print("Going to update to droplet image")
        case "Airborne":
            print("Going to update to airborne")
        case "Contact Enteric":
            print("Going to update to contact enteric")
        default:
            print("Going to use the default image")
        }
        return tempImg
    }
    var titleText: NSMutableAttributedString {
        let mainLabel = NSMutableAttributedString()
        
        let violationName = "\(self.report.healthPractice.name) Violation "
        let violationNameAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18)]
        let violationAttributedString = NSAttributedString(string: violationName, attributes: violationNameAttributes)
        mainLabel.append(violationAttributedString)
        
        let formattedDate = Report.dateHelper(self.report.date)
        let dateAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        let dateAttributedString = NSAttributedString(string: formattedDate, attributes: dateAttributes)
        mainLabel.append(dateAttributedString)
        
        return mainLabel
    }
    var nameText: NSMutableAttributedString {
        let nameLabel = NSMutableAttributedString()
        nameLabel.append(NSAttributedString(string: "Committed by: "))
        
        let employeeName = "\(self.report.employee.firstName) \(self.report.employee.surname)"
        let employeeNameAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let employeeAttributedString = NSAttributedString(string: employeeName, attributes: employeeNameAttributes)
        
        nameLabel.append(employeeAttributedString)
        return nameLabel
    }
    var locationText: NSMutableAttributedString {
        let locationLabel = NSMutableAttributedString()
        locationLabel.append(NSAttributedString(string: "Location: "))
        
        let locationNames = "\(self.report.location.facilityName) Unit \(self.report.location.unitNum) Room \(self.report.location.roomNum)"
        let locationNamesAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let locationAttributedString = NSAttributedString(string: locationNames, attributes: locationNamesAttributes)
        
        locationLabel.append(locationAttributedString)
        return locationLabel
    }
    
    // MARK: Init
    init(report: Report) {
        self.report = report
    }
}
