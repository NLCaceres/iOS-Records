//
//  CreateReportVcPickerConfig.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

/* Configures the HealthPractice picker + the Location Picker */
extension CreateReportViewController: UIPickerViewDataSource {
    // # of Columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // If HealthPractice tag then return 1, TODO: else should return 3 for location facility, room, & unit
        return (pickerView.tag == 1) ? 1 : 1
    }
    
    // # of Rows per column number - Add 1 to account for placeholder at 0-index
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let optionCount = (pickerView.tag == 1) ? self.viewModel.healthPracticePickerOptions.count
            : self.viewModel.locationPickerOptions.count
        return optionCount + 1 // Add 1 for the titleRow (a unselectable row)
    }
}

extension CreateReportViewController: UIPickerViewDelegate {
    // On Select
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 { // HealthPracticePicker Tag
            if row > 0 {
                let newHealthPractice = self.viewModel.healthPracticePickerOptions[row - 1]
                self.viewModel.reportHealthPractice = newHealthPractice
                self.topNavBar.title = "New \(newHealthPractice.name) Report"
            }
            else { self.viewModel.reportHealthPractice = nil }
        }
        // LocationPicker Tag (aka 2)
        else { self.viewModel.reportLocation = (row == 0) ? nil : self.viewModel.locationPickerOptions[row - 1] }
    }
    // Row data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Subtract row index by 1 to account for placeholder at 0-index
        
        if pickerView.tag == 1 { // Health Practice Tag
            return (row == 0) ? "Choose Health Practice" : self.viewModel.healthPracticePickerOptions[row - 1].name
        }
        else { // Location Tag = 2
            if row > 0 {
                let facilityName = self.viewModel.locationPickerOptions[row-1].facilityName
                let unitNum = self.viewModel.locationPickerOptions[row - 1].unitNum
                let roomNum = self.viewModel.locationPickerOptions[row - 1].roomNum
                return "\(facilityName) \(unitNum) \(roomNum)"
            }
            else { return "Facility Unit Room" }
            // TODO: Refactor to switch statement returning facility, room, unit depending on which column it is
        }
    }
}
