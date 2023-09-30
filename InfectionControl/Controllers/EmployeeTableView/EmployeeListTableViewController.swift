//
//  EmployeeListTableViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit
import Combine

class EmployeeListTableViewController: UITableViewController, BaseStyling {

    // MARK: IB Outlets
    var searchController: UISearchController!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBAction func cancelFindEmployee(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // IF I wanted to directly unit test the controller, then using "init()" would make dependency injection easier
    // BUT more likely to simply observe results while XCUITesting
    // MARK: Properties
    let viewModel = EmployeeListViewModel()
    var cancellables = [AnyCancellable]() // Can't make private or else SearchController extensions can't reach it
    
    // Hacky double tap helpers
    var lastClick: TimeInterval?
    var lastClickedCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.view.backgroundColor = self.backgroundColor
        self.tableView.separatorColor = self.themeColor
        
        viewModel.doneButtonEnabled.sink { isEnabled in self.selectButton.isEnabled = isEnabled }.store(in: &cancellables)
        
        viewModel.$isLoading.receive(on: DispatchQueue.main)
            .sink { $0 ? self.tableView.refreshControl?.beginRefreshing() : self.tableView.refreshControl?.endRefreshing() }
            .store(in: &cancellables)
        self.tableView.refreshControl = setUpRefreshControl(title: "Fetching Employee List", view: self, action: #selector(fetchEmployees))
        
        setUpSearchController() /// Call extension: ``EmployeeListTableViewController/setUpSearchController()``
        
        viewModel.$employeeList.receive(on: DispatchQueue.main)
            .sink { newEmployeeList in self.tableView.reloadData() }
            .store(in: &cancellables)
        
        fetchEmployees()
    }
    
    // MARK: HTTP Methods
    @objc private func fetchEmployees() {
        Task { await viewModel.getEmployeeList() } // Use a task to fire off async func, replacing DispatchQueue.global().async { }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === selectButton // Select button pressed, unwind to CreateReportVC
        else { print("The select button not pressed, cancelling"); return } // Else - cancel button tapped, dismiss w/out sending an employee to CreateReportVC
    }
}

// MARK: TableView Protocols that setup its functionality and data source
extension EmployeeListTableViewController {
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentClick = Date().timeIntervalSince1970
        if let lastClick = lastClick, let lastClickedCell = lastClickedCell {
            if (currentClick - lastClick < 0.5) && (indexPath == lastClickedCell) {
                print("Double clicked!")
            }
        }
                
        let (rowIndex, _) = viewModel.selectEmployee(index: indexPath.row) // Find the employee in main list
        
        if viewModel.filteringBegan() { // If search controller being used, then user is done searching
            searchController.dismiss(animated: true, completion: nil) // Close it, technically reopening main controller
            let indexPath = IndexPath(row: rowIndex, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle) // And select that row in main controller
        }
        
        lastClick = currentClick
        lastClickedCell = indexPath
    }
    
    // MARK: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteringBegan() ? viewModel.filteredEmployeeList.count : viewModel.employeeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Normal Styling
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeListTableViewCell.identifier, for: indexPath) as! EmployeeListTableViewCell
        cell.viewModel = EmployeeListTableCellViewModel(employee: viewModel.getEmployee(index: indexPath.row))
        return cell
    }
}
