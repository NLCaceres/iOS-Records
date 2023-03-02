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
        // Following publisher can replace using UISearchResultsUpdating protocol
        searchController.searchBar.publisher(for: \.text)
            .debounce(for: 0.5, scheduler: RunLoop.main).removeDuplicates()
            .sink { [weak viewModel] in
                viewModel?.filterEmployeeList(searchTerm: $0)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        navigationItem.searchController = searchController // Place the search bar in the navigation bar.
        navigationItem.hidesSearchBarWhenScrolling = false // Keep it visible.
        definesPresentationContext = true // Ensure searchController can present modally over root controller (employeeTableView)
    }
}

// MARK: SearchBar Delagate + Results Updater
extension EmployeeListTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    // Delegate Funcs
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.selectEmployee(index: -1) // Effectively disables selectButton by unselecting any emploee
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.selectEmployee(index: -1) // Effectively disables selectButton
    }
    
    // This is similar to the searchBarDelegate, it fires off events every new char
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterEmployeeList(searchTerm: searchController.searchBar.text)
        tableView.reloadData()
    }
}

// OPTIONAL:
// UISearchControllerDelegate AND UIStateRestoring
// UISearchControllerDelegate listens in on searchController lifecycle
// UIStateRestoring can help save previous controller state (Title, firstResponder, etc.)
