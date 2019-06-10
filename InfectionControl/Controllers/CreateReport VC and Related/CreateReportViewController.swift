//
//  CreateReportViewController.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/20/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import os.log

class CreateReportViewController: UIViewController {
    
    // Properties
    let viewModel = CreateReportViewModel()
    let disposeBag = DisposeBag()
    let healthPracticeEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/healthpractices")
    let locationEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/locations")
    var healthPractices: [HealthPractice] = [HealthPractice]()
    var locations: [Location] = [Location]()
    
    // Report Properties
    var reportEmployee: Employee?
    var reportHealthPractice: HealthPractice?
    var reportLocation: Location?
//    var reportLocationFacility: String?
//    var reportLocationUnit: String?
//    var reportLocationRoom: String?
    var reportDate: Date?
    var fullReport: Report?
    
    // Interface Builder Props
    @IBOutlet weak var topNavBar: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancelNewReport(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var findEmployeeTextField: UITextField!
    private let employeeListSegue = "EmployeeListSegue"
    @IBAction func searchEmployee(_ sender: Any) {
        self.performSegue(withIdentifier: employeeListSegue, sender: self)
    }
    @IBAction func unwindToCreateReportVC(sender: UIStoryboardSegue) {
        print("This should be working now")
        if let sourceViewController = sender.source as? EmployeeListTableViewController {
            reportEmployee = sourceViewController.selectedEmployee
            if let employee = reportEmployee {
                findEmployeeTextField.text = "\(employee.firstName) \(employee.surname)"
                enableSaveButtonHelper()
            }
        }
    }
    
    @IBOutlet weak var healthPracticePicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dateChanged(_ sender: Any) {
        if let datePicker = sender as? UIDatePicker {
            reportDate = datePicker.date
            enableSaveButtonHelper()
            Report.dateHelper(reportDate!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavBar.title = "New \(viewModel.reportPracticeType) Report"
        // Hacky way to prevent keyboard from appearing on textField
        findEmployeeTextField.inputView = UIView()
        
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        datePicker.maximumDate = Date()
        
        DataHandler.fetchJSONData(self.healthPracticeEndpoint, decodeHealthPractices)
        DataHandler.fetchJSONData(self.locationEndpoint, decodeLocations)
        //DataHandler.fetchJSONData(viewModel.healthPracticeEndpoint, viewModel.decodeHealthPractices)
        //healthPracticePicker.rx.
        //DataHandler.fetchJSONData(viewModel.locationEndpoint, viewModel.decodeLocations)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        guard let reportDate = reportDate else {
            print("Date not set")
            return
        }
        fullReport = Report(employee: reportEmployee, healthPractice: reportHealthPractice, location: reportLocation, date: reportDate)
        let url = URL(string: "http://127.0.0.1:3000/api/reports/create")!
        
        var postRequest = URLRequest(url: url)
        // Configuration for a proper request (for the server)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        do {
            let jsonReport = try JSONEncoder().encode(fullReport)
            let putTask = URLSession.shared.uploadTask(with: postRequest, from: jsonReport, completionHandler: {data, response, error in
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Data was returned")
                    print(dataString)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("Received a response: \(httpResponse.statusCode)")
                }
            })
            putTask.resume()
        } catch {
            print("JSON or Encode error: \(error.localizedDescription)")
        }
    }
    
    func enableSaveButtonHelper() {
        if reportEmployee != nil && reportHealthPractice != nil && reportLocation != nil && reportDate != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func decodeHealthPractices(data: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedHealthPractices = try jsonDecoder.decode([HealthPractice].self, from: data)
            for decodedHealthPractice in decodedHealthPractices {
                print("This is the decoded health practice \(decodedHealthPractice)")
//                guard let precautionType = decodedHealthPractice.precautionType else {
//                    print("Missing the precautionType for some reason")
//                    return
//                }
                healthPractices.append(decodedHealthPractice)
            }
            
            DispatchQueue.main.async {
                print("This is the number of rows in health practices that we should see: \(self.healthPractices.count)")
                self.healthPracticePicker.reloadAllComponents()
                if let healthPracticePickerRow = self.healthPractices.firstIndex(where: { $0.name == self.viewModel.reportPracticeType }) {
                    print("This is the healthPractice row: \(healthPracticePickerRow)")
                    self.healthPracticePicker.selectRow(healthPracticePickerRow+1, inComponent: 0, animated: true)
                }
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
                self.locationPicker.reloadAllComponents()
            }
            
        } catch {
            print("Error in decodeHealthPractices: \(error)")
        }
    }

}

extension CreateReportViewController: UIPickerViewDataSource {
    // Column number
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Health Practice Tag = 1
        if (pickerView.tag == 1) {
            return 1
        }
        // Location Tag is = 2
        else {
            return 1
            // If I want 3 columns then I need to refactor Location Model
            //return 3
        }
    }
    
    // Row per column number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // All have added 1 to account for pickerview placeholder in index 0
        
        // Health Practice Tag = 1
        if (pickerView.tag == 1) {
            return self.healthPractices.count + 1
            //return viewModel.healthPractices.count
        }
        // Location Tag is = 2
        else {
            return self.locations.count + 1
            //return viewModel.locations.count
        }
    }
    
}

extension CreateReportViewController: UIPickerViewDelegate {
    // handles selection, row height, and row width. Can also do a title for row
    
    // All have subtracted 1 to account for pickerview placeholder in index 0
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Health Practice Tag = 1
        if (pickerView.tag == 1) {
            if row == 0 {
                reportHealthPractice = nil
            } else {
                print("\(self.healthPractices[row - 1].name)")
                self.topNavBar.title = "New \(self.healthPractices[row - 1].name) Report"
                reportHealthPractice = self.healthPractices[row - 1]
            }
            //print("\(viewModel.healthPractices[row].name)")
        }
        // Location Tag is = 2
        else {
            if row == 0 {
                reportLocation = nil
            } else {
                print("\(self.locations[row-1].facilityName) \(self.locations[row-1].unitNum) \(self.locations[row-1].roomNum)")
                reportLocation = self.locations[row-1]
            }
//            switch component {
//            case 0:
//                if row == 0 {
//                    reportLocationFacility = nil
//                } else {
//                    print("\(self.locations[row - 1].facilityName)")
//                    reportLocationFacility = self.locations[row - 1].facilityName
//                }
//                //print("\(viewModel.locations[row].facilityName)")
//            case 1:
//                if row == 0 {
//                    reportLocationUnit = nil
//                } else {
//                    print("\(self.locations[row - 1].unitNum)")
//                    reportLocationUnit = self.locations[row - 1].unitNum
//                }
//                //print("\(viewModel.locations[row].unitNum)")
//            case 2:
//                if row == 0 {
//                    reportLocationRoom = nil
//                } else {
//                    print("\(self.locations[row - 1].roomNum)")
//                    reportLocationRoom = self.locations[row - 1].roomNum
//                }
//                //print("\(viewModel.locations[row].roomNum)")
//            default:
//                print("Nothing here!")
//            }
        }
        enableSaveButtonHelper()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // All have subtracted 1 to account for pickerview placeholder in index 0
        
        // Health Practice Tag = 1
        if (pickerView.tag == 1) {
            if row == 0 {
               return "Choose Health Practice"
            }
            return self.healthPractices[row - 1].name
            //return viewModel.healthPractices[row].name
        }
        // Location Tag is = 2
        else {
            if row == 0 {
                return "Facility Unit Room"
            }
            return "\(self.locations[row-1].facilityName) \(self.locations[row-1].unitNum) \(self.locations[row-1].roomNum)"
//            switch component {
//            case 0:
//                if row == 0 {
//                    return "Facility"
//                }
//                return self.locations[row - 1].facilityName
//                //return viewModel.locations[row].facilityName
//            case 1:
//                if row == 0 {
//                    return "Unit"
//                }
//                return self.locations[row - 1].unitNum
//                //return viewModel.locations[row].unitNum
//            case 2:
//                if row == 0 {
//                    return "Room"
//                }
//                return self.locations[row - 1].roomNum
//                //return viewModel.locations[row].roomNum
//            default:
//                return "Location Info"
//            }
        }
    }
}
