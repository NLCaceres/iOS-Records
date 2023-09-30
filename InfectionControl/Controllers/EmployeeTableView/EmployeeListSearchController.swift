//
//  EmployeeListSearchController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

extension EmployeeListTableViewController {
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil) // Using nil means use EmployeeListTableVC
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.searchBar.searchTextField.backgroundColor = self.themeColor
        searchController.searchBar.searchTextField.leftView?.tintColor = self.themeSecondaryColor // Changes icon color
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by name or profession",
                                                                                              attributes: [.foregroundColor: UIColor.yellow])
        
        // searchController.searchBar.publisher(for: \.text) SHOULD work with a debounce + sink BUT seems Apple never actually implemented it
        // so it never emits events, leaving the following combined with UISearchResultsUpdating as the better choice
        viewModel.$searchTerm.debounce(for: 0.5, scheduler: DispatchQueue.main).removeDuplicates()
            .sink { [weak self] in
                self?.viewModel.filterEmployeeList(searchTerm: $0)
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        navigationItem.searchController = searchController // Place the search bar in the navigation bar.
        navigationItem.hidesSearchBarWhenScrolling = false // Keep it visible.
        definesPresentationContext = true // Ensure searchController can present modally over root controller (employeeTableView)
    }
}

// MARK: SearchBar Delagate + Results Updater
extension EmployeeListTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    // Delegate Funcs
    // Following called just before searchBarShouldEndEditing(_), so nav buttons will reappear above list
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.beginSearching(false)
        viewModel.selectEmployee(index: -1) // Effectively disables selectButton by unselecting any emploee
    }
    // Following called after searchTextField tapped and user can begin typing, called just after searchBarShouldBeginEditing(_)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.beginSearching(true)
        viewModel.selectEmployee(index: -1) // Effectively disables selectButton
    }
    
    // This is similar to the searchBarDelegate, it fires off events every new char
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchTerm(searchController.searchBar.text)
    }
}

// OPTIONAL:
// UISearchControllerDelegate AND UIStateRestoring
// UISearchControllerDelegate listens in on searchController lifecycle
// UIStateRestoring can help save previous controller state (Title, firstResponder, etc.)
