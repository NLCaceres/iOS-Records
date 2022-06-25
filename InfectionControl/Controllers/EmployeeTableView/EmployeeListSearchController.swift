//
//  EmployeeListSearchController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

extension EmployeeListTableViewController {
    func setUpSearchController() {
        // (searchResultsController: nil) means use THIS VC to display results
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.searchBar.searchTextField.backgroundColor = self.themeColor
        searchController.searchBar.searchTextField.leftView?.tintColor = self.themeSecondaryColor // Changes icon color
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by name or profession",
                                                                                              attributes: [.foregroundColor: UIColor.yellow])
        
        navigationItem.searchController = searchController // Place the search bar in the navigation bar.
        navigationItem.hidesSearchBarWhenScrolling = false // Keep it visible.
        definesPresentationContext = true // Ensure searchController can present modally over root controller (employeeTableView)
    }
}

// MARK: SearchBar Delagate + Results Updater
extension EmployeeListTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    // Delegate Funcs
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectButton.isEnabled = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        selectButton.isEnabled = false
    }
    
    // This is similar to the searchBarDelegate, it fires off events every new char
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        filteredEmployees = employees.filter { employee in
            let pattern = #"\b"# + searchText
            let searchRegex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let employeeFullName = "\(employee.firstName) \(employee.surname)"
            guard let employeeProfession = employee.profession else {
                print("For some reason no profession present in return")
                return false
            }
            let profession = "\(employeeProfession.observedOccupation) \(employeeProfession.serviceDiscipline)"
            let fullEmployeeInfo = employeeFullName + " " + profession
            
            return searchRegex?.firstMatch(in: fullEmployeeInfo, range: NSRange(location: 0, length: fullEmployeeInfo.count)) != nil ?
                true : false
        }
        self.tableView.reloadData()
    }
}

// OPTIONAL:
// UISearchControllerDelegate AND UIStateRestoring
// UISearchControllerDelegate listens in on searchController lifecycle
// UIStateRestoring can help save previous controller state (Title, firstResponder, etc.)
