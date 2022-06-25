//
//  EmployeeListTableViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class EmployeeListTableViewController: UITableViewController, BaseStyling {

    // MARK: IB Outlets
    var searchController: UISearchController!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBAction func cancelFindEmployee(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Properties
    var networkManager: CompleteNetworkManager = NetworkManager()
    var employees = [Employee]()
    var filteredEmployees = [Employee]()
    var selectedEmployee: Employee?
    var filteredEmployeesRx: PublishSubject<[Employee]> = PublishSubject()
    private let disposeBag = DisposeBag()
    let reuseIdentifier = "EmployeeListTableViewCell"
    // Hacky double tap helpers
    var lastClick: TimeInterval?
    var lastClickedCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.view.backgroundColor = self.backgroundColor
        self.tableView.separatorColor = self.themeColor
        
        self.tableView.refreshControl = setUpRefreshControl(title: "Fetching Employee List", view: self, action: #selector(fetchEmployees))
        setUpSearchController()
        
        fetchEmployees()
    }
    
    func isFiltering() -> Bool { // SearchController must be Active and NOT Empty
        // If optionalChain fails, text is nil, so coalesce, return true as if the text is empty.
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    // MARK: HTTP Methods
    @objc func fetchEmployees() {
        self.tableView.refreshControl?.beginRefreshing()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let myVC = self else { return } // Need self or following weak ref calls won't work of course!
            myVC.networkManager.createFetchTask(endpointPath: "employees", updateClosure: myVC.decodeEmployeeList).resume()
        }
    }
    func decodeEmployeeList(data: Data?, err: Error?) {
        guard let employeeData = data else { return }
        
        if let decodedEmployees = employeeData.toArray(containing: EmployeeDTO.self) {
            for decodedEmployee in decodedEmployees {
//                print("This is the decoded report \(decodedEmployee)")
                guard decodedEmployee.profession != nil else {
                    print("Missing profession for some reason")
                    return
                }
                employees.append(decodedEmployee.toBase())
            }
        }
        else {
            // TODO: Render err
        }
        
        DispatchQueue.main.async { // No func here expected to be long running so no capture list
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button === selectButton
        else { print("The select button not pressed, cancelling"); return }
    }
}

extension EmployeeListTableViewController {
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentClick: TimeInterval = Date().timeIntervalSince1970
        if let lastClick = lastClick, let lastClickedCell = lastClickedCell {
            if (currentClick - lastClick < 0.5) && (indexPath == lastClickedCell) {
                print("Double clicked!")
            }
        }
        selectButton.isEnabled = true
        if isFiltering() {
            selectedEmployee = filteredEmployees[indexPath.row]
            searchController.dismiss(animated: true, completion: nil)
            let rowIndex = employees.firstIndex { $0.id == selectedEmployee!.id }
            let indexPath = IndexPath(row: rowIndex!, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
        else { selectedEmployee = employees[indexPath.row] }
        
        lastClick = currentClick
        lastClickedCell = indexPath
    }
    
    // MARK: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredEmployees.count : employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Normal Styling
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EmployeeListTableViewCell
        cell.backgroundColor = self.backgroundColor
        
        // On Selection Styling
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = self.themeColor.withAlphaComponent(0.7)
        cell.selectedBackgroundView = selectedBackground

        let employee = isFiltering() ? filteredEmployees[indexPath.row] : employees[indexPath.row]
        
        cell.employeeNameLabel.text = "\(employee.firstName) \(employee.surname)"
        cell.employeeNameLabel.highlightedTextColor = self.themeSecondaryColor // On Selection Styling
        if let profession = employee.profession {
            cell.employeeProfessionLabel.text = "\(profession.observedOccupation) \(profession.serviceDiscipline)"
            cell.employeeProfessionLabel.highlightedTextColor = self.themeSecondaryColor.withAlphaComponent(0.9) // On Selection Styling
        }

        return cell
    }
}
