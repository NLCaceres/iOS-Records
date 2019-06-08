//
//  EmployeeListTableViewController.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/30/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import os.log

class EmployeeListTableViewController: UITableViewController {

    // IB Outlets
    private var searchController: UISearchController!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBAction func cancelFindEmployee(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Properties
    var employees = [Employee]()
    var filteredEmployees = [Employee]()
    var selectedEmployee: Employee?
    var filteredEmployeesRx: PublishSubject<[Employee]> = PublishSubject()
    private let disposeBag = DisposeBag()
    let reuseIdentifier = "EmployeeListTableViewCell"
    // Hacky double tap helpers
    var lastClick: TimeInterval?
    var lastClickedCell: IndexPath?
    
    // Data Endpoint
    private let employeeEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/employees")
    private let urlSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        
        // Nil here means use the same view to display results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search by name or profession"
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        
// Deprecated - searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        
        // Essential to keep the searchController in proper VC (and prevent weird bugs)
        // By setting this, you define it as the root VC for the searchController to present modally over
        definesPresentationContext = true
        
        fetchEmployees()

    }
    
    // SIMPLE HELPER FUNCTIONS
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEmployees.count
        }
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EmployeeListTableViewCell
        let employee:Employee
        if isFiltering() {
            employee = filteredEmployees[indexPath.row]
        } else {
            employee = employees[indexPath.row]
        }
        
        cell.employeeNameLabel.text = "\(employee.firstName) \(employee.surname)"
        if let profession = employee.profession {
            cell.employeeProfessionLabel.text = "\(profession.observedOccupation) \(profession.serviceDiscipline)"
        }

        return cell
    }
    
    // HANDLE JSON CALL METHODS
    
    func fetchEmployees() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            let fetchJSONTask = DataHandler.fetchTaskCreater(self.employeeEndpoint, self.decodeEmployeeList)
            fetchJSONTask.resume()
        }
    }
    
    func decodeEmployeeList(data: Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedEmployees = try jsonDecoder.decode([Employee].self, from: data)
            for decodedEmployee in decodedEmployees {
                print("This is the decoded report \(decodedEmployee)")
                if decodedEmployee.profession == nil {
                    print("Missing profession for some reason")
                    return
                }
                employees.append(decodedEmployee)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
            
        } catch {
            print("Error in updateReports: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentClick: TimeInterval = Date().timeIntervalSince1970
        if let lastClick = lastClick, let lastClickedCell = lastClickedCell {
            if (currentClick - lastClick < 0.5) && (indexPath == lastClickedCell) {
                //print("Yep that was a double click")
            }
        }
        selectButton.isEnabled = true
        if isFiltering() {
            selectedEmployee = filteredEmployees[indexPath.row]
            searchController.dismiss(animated: true, completion: nil)
            let rowIndex = employees.firstIndex(where: {$0.id == selectedEmployee!.id})
            let indexPath = IndexPath(row: rowIndex!, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        } else {
            selectedEmployee = employees[indexPath.row]
        }
        lastClick = currentClick
        lastClickedCell = indexPath
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button === selectButton else {
            os_log("The select button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
    
}

extension EmployeeListTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectButton.isEnabled = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        selectButton.isEnabled = false
    }
}

extension EmployeeListTableViewController: UISearchResultsUpdating {
    // This is similar to the searchBarDelegate, it fires off events every new char
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        filteredEmployees = employees.filter({(employee: Employee) -> Bool in
            let pattern = #"\b"# + searchText
            let searchRegex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let employeeFullName = "\(employee.firstName) \(employee.surname)"
            guard let employeeProfession = employee.profession else {
                print("For some reason no profession present in return")
                return false
            }
            let profession = "\(employeeProfession.observedOccupation) \(employeeProfession.serviceDiscipline)"
            let fullEmployeeInfo = employeeFullName + " " + profession
            
            let matchFound = searchRegex?.firstMatch(in: fullEmployeeInfo, options: [], range: NSRange(location: 0, length: fullEmployeeInfo.utf16.count)) != nil
            if matchFound {
                return true
            }
            return false
        })
        self.tableView.reloadData()
    }
}

// OPTIONAL:
// UISearchControllerDelegate AND UIStateRestoring
// UISearchControllerDelegate listens in on searchController lifecycle
// UIStateRestoring can help save previous controller state (Title, firstResponder, etc.)
