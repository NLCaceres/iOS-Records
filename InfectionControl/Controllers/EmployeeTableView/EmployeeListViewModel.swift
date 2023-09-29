//
//  EmployeeListViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import Combine

class EmployeeListViewModel: ObservableObject {
    
    // MARK: Properties
    private let employeeRepository: EmployeeRepository
    
    @Published private(set) var isLoading = false
    @Published private(set) var employeeList = [Employee]()
    
    @Published private(set) var searching = false // Indicates search bar is open and user is ready to enter text
    @Published private(set) var searchTerm = ""
    @Published private(set) var filteredEmployeeList = [Employee]()
    @Published private(set) var selectedEmployee: Employee? = nil
    
    var doneButtonEnabled: AnyPublisher<Bool, Never> { // Read-only/Getter properties don't need, and can't use, private(set)
        $selectedEmployee.map { $0 != nil }.eraseToAnyPublisher() // Observe selectedEmployees and enable done button if not nil
    }
    
    init(employeeRepository: EmployeeRepository = AppEmployeeRepository()) {
        self.employeeRepository = employeeRepository
    }
    
    func getEmployeeList() async {
        isLoading = true
        do {
            employeeList = try await employeeRepository.getEmployeeList()
        } catch {
            print(error.localizedDescription) // Render error message
        }
        isLoading = false
    }
    func getEmployee(index: Int) -> Employee {
        return filteringBegan() ? filteredEmployeeList[index] : employeeList[index]
    }
    func updateSearchTerm(_ term: String?) {
        searchTerm = term ?? ""
    }
    func filterEmployeeList(searchTerm: String) {
        // Take the most recent array of employees, looking for matching names BUT ensure the Char's case is not a concern via lowercased()
        filteredEmployeeList = employeeList.filter { employee in
            let pattern = #"\b"# + searchTerm
            let searchRegex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            guard let employeeProfession = employee.profession else {
                print("Employee missing profession for some reason")
                return false
            }
            let fullEmployeeInfo = "\(employee.fullName.lowercased()) \(employeeProfession.description.lowercased())"

            return searchRegex?.firstMatch(in: fullEmployeeInfo, range: NSRange(location: 0, length: fullEmployeeInfo.count)) != nil
        }
    }
    @discardableResult // May not need to even use the result in all cases but return it for easy usage anyway!
    func selectEmployee(index: Int) -> (Int, Employee?) { // Use tableView index to grab correct employee from arrays
        if (index < 0) { // Unselect currently selected employee
            selectedEmployee = nil // Allows doneButton to be disabled
            return (-1, selectedEmployee) // Return the usual tuple but now its (-1, nil)
        }
        if (filteringBegan()) {
            selectedEmployee = filteredEmployeeList[index]
        }
        else {
            selectedEmployee = employeeList[index]
        }
        let index = employeeList.firstIndex { $0.id == selectedEmployee!.id }
        return (index ?? -1, selectedEmployee)
    }
    
    func beginSearching(_ start: Bool) {
        searching = start
    }
    func filteringBegan() -> Bool { // Instead of using searchBar.combineLatest(searchTerm), just combine underlying values when needed
        return searching && !searchTerm.isEmpty // Why? Because on eraseToAnyPublisher(), AnyPublisher has no recent value property
    } // BUT CurrentValueSubject does! Problem is there's no way to convert to a specific type of Swift Combine Publisher
    // It is technically possible to use the erased AnyPublisher left over to react and then currentValSubj.send(anyPubValue)
    // BUT unless you're calling sink() on the currentValSubj, directly accessing the recent value property may NOT ALWAYS get the most recent combined/transformed val
}
