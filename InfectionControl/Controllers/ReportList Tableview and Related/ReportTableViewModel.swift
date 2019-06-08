//
//  ReportTableViewModel.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/22/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import Foundation
import RxSwift

// View Models can be plain or smart
// Smart is what we're after
// Plain would be just something that holds data and serves it to the controller/view
// Smart handles a lot more data interactions (and can be more like angular injecting dependencies
// or simpler calling endpoints internally
// Separating eliminates coupling though
class ReportTableViewModel: NSObject {
    // PROPERTIES
    let reports: PublishSubject<[Report]> = PublishSubject()
    let reportCellViewModels: PublishSubject<[ReportTableCellViewModel]> = PublishSubject()
    @objc dynamic var reportCells: [ReportTableCellViewModel]
    
    var numOfCells: Int {
        return reportCells.count
    }
    
    // Data Endpoint
    //private let endpoint = URL(string: "https://safe-retreat-87739.herokuapp.com/api/reports")
    private let mockReportEndpoint = URL(string: "http://127.0.0.1:3000/api/reports")
    private let urlSession = URLSession(configuration: .default)
    
    override init() {
        self.reportCells = [ReportTableCellViewModel]()
    }
    
    func reportCellViewModel(at index: Int) -> ReportTableCellViewModel {
        return self.reportCells[index]
    }
    
    @objc func fetchReports(_ sender: Any? = nil) {
        print("Calling fetch reports from the Report view model")
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            let fetchJSONTask = DataHandler.fetchTaskCreater(self.mockReportEndpoint!, self.updateReports)
            fetchJSONTask.resume()
        }
    }
    
    func updateReports(data: Data) {
        do {
            reportCells.removeAll()
            let jsonDecoder = JSONDecoder()
            let decodedReports = try jsonDecoder.decode([Report].self, from: data)
            for decodedReport in decodedReports {
                print("This is the decoded report \(decodedReport)")
                guard let healthPractice = decodedReport.healthPractice else {
                    print("Missing the health practice for some reason")
                    return
                }
                let cellImage = selectReportImage(healthPractice.name)
                let titleDateText = createMainLabel(decodedReport.date, healthPractice.name)
                guard let employee = decodedReport.employee else {
                    print("Missing the employee for some reason")
                    return
                }
                let nameText = createNameLabel(employee)
                guard let location = decodedReport.location else {
                    print("Missing location for some reason")
                    return
                }
                let locationText = createLocationLabel(location)
                let reportCell = ReportTableCellViewModel(image: cellImage, title: titleDateText, name: nameText, location: locationText)
                // If I add this to publishSubject I can tableview reload repeatedly (as each event fires)
                // Still a question of how do I call it from here?
                reportCells.append(reportCell)
            }
            
            DispatchQueue.main.async {
                print("This is the number of cells it should be: \(self.numOfCells)")
            }
            
        } catch {
            print("Error in updateReports: \(error)")
        }
    }
    
    func selectReportImage(_ healthPracticeName: String) -> UIImage {
        var image: UIImage = #imageLiteral(resourceName: "report_placeholder_icon")
        switch healthPracticeName {
        case "Hand Hygiene":
            print("Going to update to hand hygiene image")
        case "PPE":
            print("Going to update to PPE image")
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
        return image
    }
    
    func createMainLabel(_ date: Date, _ healthPracticeName: String) -> NSMutableAttributedString {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, hh:mma"
        let formattedDate = dateFormatter.string(from: date)
        let dateAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        let dateAttributedString = NSAttributedString(string: formattedDate, attributes: dateAttributes)
        
        let violationName = "\(healthPracticeName) Violation "
        let violationNameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        let violationAttributedString = NSAttributedString(string: violationName, attributes: violationNameAttributes)
        
        let mainLabel = NSMutableAttributedString()
        mainLabel.append(violationAttributedString)
        mainLabel.append(dateAttributedString)
        
        return mainLabel
    }
    
    func createNameLabel(_ employee: Employee) -> NSMutableAttributedString {
        let nameLabel = NSMutableAttributedString()
        nameLabel.append(NSAttributedString(string: "Committed by: "))
        
        let employeeName = "\(employee.firstName) \(employee.surname)"
        let employeeNameAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let employeeAttributedString = NSAttributedString(string: employeeName, attributes: employeeNameAttributes)
        
        nameLabel.append(employeeAttributedString)
        return nameLabel
    }
    
    func createLocationLabel(_ location: Location) -> NSMutableAttributedString {
        let locationLabel = NSMutableAttributedString()
        locationLabel.append(NSAttributedString(string: "Location: "))
        
        let locationNames = "\(location.facilityName) Unit \(location.unitNum) Room \(location.roomNum)"
        let locationNamesAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let locationAttributedString = NSAttributedString(string: locationNames, attributes: locationNamesAttributes)
        
        locationLabel.append(locationAttributedString)
        return locationLabel
    }
}
