//
//  CreateReportViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit
import Combine

class CreateReportViewController: UIViewController, BaseStyling {
    
    // MARK: Standard Properties
    let viewModel = CreateReportViewModel()
    private var cancellables: Set<AnyCancellable> = [] // To dispose subs later

    // MARK: IBOutlets
    @IBOutlet weak var topNavBar: UINavigationItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancelNewReport(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var findEmployeeTextField: UITextField!
    private let employeeListSegue = "EmployeeListSegue"
    @objc func searchEmployee(gesture: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: employeeListSegue, sender: self)
    }
    
    @IBOutlet weak var healthPracticePicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dateChanged(_ sender: Any) { changeDate(sender) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the top navbar
        if let reportPracticeType = self.viewModel.reportHealthPractice?.name {
            self.topNavBar.title = "New \(reportPracticeType) Report"
        } else { self.topNavBar.title = "New Report" }

        self.view.backgroundColor = self.backgroundColor
        
        self.configEmployeeTextField()
        
        self.configDatePicker()
        
        self.bindViewModel()
        Task { [weak viewModel] in await viewModel?.beginFetching() } // Task runs immediately and wraps async work
    }
    
    func configEmployeeTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchEmployee))
        tapGesture.numberOfTapsRequired = 2
        self.findEmployeeTextField.addGestureRecognizer(tapGesture)
    }
    
    // MARK: DatePicker Config
    func configDatePicker() {
        self.datePicker.contentHorizontalAlignment = .left
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        self.datePicker.maximumDate = Date()
    }
    func changeDate(_ sender: Any) {
        if let datePicker = sender as? UIDatePicker {
            self.viewModel.reportDate = datePicker.date
        }
    }
    
    // MARK: ViewModel Config
    func bindViewModel() { // Config subscriptions
        self.viewModel.$isLoading.sink { isLoading in
            print("IsLoading: \(isLoading)")
        }.store(in: &cancellables)
        
        self.viewModel.$healthPracticePickerOptions.sink { [weak self] healthPracticeArr in
            guard let myVC = self else { return }

            Task { @MainActor in
                myVC.healthPracticePicker.reloadAllComponents()
                // Name of HealthPractice is all that matters here since it's what is used to decide in a picker anyway
                let healthPracticePickerRow = myVC.viewModel.healthPracticePickerOptions.firstIndex { $0.name == myVC.viewModel.reportHealthPractice?.name }
                if let healthPracticePickerRow = healthPracticePickerRow {
                    myVC.healthPracticePicker.selectRow(healthPracticePickerRow+1, inComponent: 0, animated: true)
                }
            }
        }.store(in: &cancellables)
        
        self.viewModel.$locationPickerOptions.sink { [weak self] locationArr in
            guard let myVC = self else { return }

            Task { @MainActor in // Nicer than "Task { await MainActor.run {} }" version
                myVC.locationPicker.reloadAllComponents()
            } // and better than good ol' DispatchQueue.main.async
        }.store(in: &cancellables)
        
        self.viewModel.saveButtonEnabled.sink { [weak self] isEnabled in
            guard let myVC = self else { return }
            
            Task { @MainActor in
                print("Running save button sub: \(isEnabled)")
                myVC.saveButton.isEnabled = isEnabled
            }
        }.store(in: &cancellables)
        
        setupErrorMessage()
    }
    
    func setupErrorMessage() { // TODO: Insert into view, let viewModel determine message based on error type?
        self.viewModel.$errorMessage.sink {
            print("Received the following error - \($0)")
        }.store(in: &cancellables)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Only handles saveButton, backButton handles itself
        guard let button = sender as? UIBarButtonItem, button === saveButton
        else { print("Save button not pressed, Cancel button was. Going back in Nav stack"); return }
        
        Task { await self.viewModel.postNewReport() }
    }
    @IBAction func unwindToCreateReportVC(sender: UIStoryboardSegue) {
        if let employeeListVc = sender.source as? EmployeeListTableViewController {
            self.viewModel.reportEmployee = employeeListVc.viewModel.selectedEmployee
            if let employee = self.viewModel.reportEmployee {
                // SHOULD always be non-nil but using "if let" avoids "nil nil" appearing in the textField
                findEmployeeTextField.text = "\(employee.firstName) \(employee.surname)"
            }
        }
    }
}

// MARK: Bonus TextField Config
extension CreateReportViewController: UITextFieldDelegate {
    // This prevents keyboard opening + prevents editing employee name once chosen
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { false }
}
