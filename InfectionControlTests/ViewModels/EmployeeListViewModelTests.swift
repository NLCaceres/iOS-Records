//
//  EmployeeListViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

final class EmployeeListViewModelTests: XCTestCase {
    var employeeRepository: MockEmployeeRepository!
    var viewModel: EmployeeListViewModel!
    
    override func setUp() {
        employeeRepository = MockEmployeeRepository()
        employeeRepository.populateList()
        viewModel = EmployeeListViewModel(employeeRepository: employeeRepository)
    }
    
    func testEmployeeListFetchAndLoad() async throws {
        var cancellables = Set<AnyCancellable>()

        var loadingChanges = 0
        viewModel.$isLoading.sink { // Monitor isLoading values as fetch called -F--T--F-->
            (loadingChanges % 2 == 0) ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingChanges += 1
        }.store(in: &cancellables)

        XCTAssertEqual(viewModel.employeeList, []) // Starts as empty list
        await viewModel.getEmployeeList() // Now should update value to repository's value
        XCTAssertEqual(viewModel.employeeList.count, 5) // Updated to expected mockList
    }
    func testGetSingleEmployee() async throws {
        await viewModel.getEmployeeList() // Populate the list
        let employee = viewModel.getEmployee(index: 3) // Get employee at row 2 (Counting from 1)
        XCTAssertEqual(employee.fullName, "Melody Rios")

        // WHEN the search bar is open BUT no text tracked in the search bar
        viewModel.beginSearching(true)
        viewModel.filterEmployeeList(searchTerm: "Chamb") // Filter the employee list
        XCTAssertEqual(viewModel.filteredEmployeeList.count, 1)
        let normalEmployee = viewModel.getEmployee(index: 0) // THEN still get an employee from normal ListView at 1st row
        XCTAssertEqual(normalEmployee.fullName, "John Smith")
        
        // WHEN the search bar is open AND text entered into search bar
        viewModel.updateSearchTerm("Chamb")
        viewModel.filterEmployeeList(searchTerm: "Chamb")
        XCTAssertEqual(viewModel.filteredEmployeeList.count, 1)
        let filteredEmployee = viewModel.getEmployee(index: 0)
        XCTAssertEqual(filteredEmployee.fullName, "Jill Chambers") // THEN filteringBegan() == true, so the filtered list is used to find the employee
        
        // In-app, the search bar is tracked so it can call updateSearchTerm(), which in turn emits debounced text to filterEmployeeList()
        // In unit tests, calling updateSearchTerm() is ONLY for ensuring filteringBegan() == true
        viewModel.updateSearchTerm("John")
        // While filterEmployeeList() + filteringBegan() are the real determinants of which list we use to grab the employee
        viewModel.filterEmployeeList(searchTerm: "Rio")
        XCTAssertEqual(viewModel.filteredEmployeeList.count, 1)
        let otherFilteredEmployee = viewModel.getEmployee(index: 0)
        XCTAssertEqual(otherFilteredEmployee.fullName, "Melody Rios") // Get "Melody Rios", not "John Smith"
        XCTAssertEqual(viewModel.searchTerm, "John") // DESPITE "John" being the tracked search term
    }
    func testFilteringBegan() throws {
        XCTAssertFalse(viewModel.filteringBegan()) // Defaults to false (since searchBar is closed + searchTerm is empty)

        viewModel.beginSearching(true)
        XCTAssertFalse(viewModel.filteringBegan()) // Still false since searchBar opened but searchTerm still empty

        // In real app, the viewModel tracks the searchBar's text, then calls filterEmployeeList()
        // W/out a tracked searchTerm, filtering can't start, so must call updateSearchTerm() to simulate a user entering text
        viewModel.updateSearchTerm("Foobar")
        XCTAssertTrue(viewModel.filteringBegan()) // True since searchBar open AND search term updated to non-empty string
    }
    func testSelectEmployee() async throws {
        var cancellables = Set<AnyCancellable>()
        var doneButtonChanged = 0 // DoneButton also is disabled based on selectedEmployee, defaulting to false (so disabled)
        viewModel.doneButtonEnabled.sink { // --F--T-F-T-F-->
            (doneButtonChanged % 2 == 0) ? XCTAssertFalse($0) : XCTAssertTrue($0)
            doneButtonChanged += 1
        }.store(in: &cancellables)
        
        // WHEN selecting an employee
        await viewModel.getEmployeeList() // Populate the list
        let (index, employee) = viewModel.selectEmployee(index: 3) // Get employee at row 2 (indexed to 0)
        // THEN get back the index used to select it + the employee itself, enabling the done button
        XCTAssertEqual(index, 3)
        XCTAssertEqual(employee!.fullName, "Melody Rios")
        XCTAssertEqual(employee, viewModel.selectedEmployee)

        // WHEN unselecting an employee via an undefined index (negative numbers or values longer than the list count)
        let (undefinedIndex, unselectedEmployee) = viewModel.selectEmployee(index: -1) // Unselect the employee
        // THEN still get back the index used BUT without an employee and disabling the done button
        XCTAssertEqual(undefinedIndex, -1)
        XCTAssertEqual(unselectedEmployee, nil)
        XCTAssertEqual(unselectedEmployee, viewModel.selectedEmployee)

        // WHEN the search bar is filtering
        viewModel.beginSearching(true) // Open the search bar
        viewModel.updateSearchTerm("Rio") // And enter text
        viewModel.filterEmployeeList(searchTerm: "Rio") // Filter the employee list
        let (originalIndex, filteredEmployee) = viewModel.selectEmployee(index: 0) // Select employee at row 1 of filtered listView
        // THEN receive the employee's index from the original list, NOT its filteredList index,
        XCTAssertEqual(originalIndex, 3)
        XCTAssertEqual(filteredEmployee!.fullName, "Melody Rios") // WITH the expected employee AND enabling the done button
        XCTAssertEqual(filteredEmployee, viewModel.selectedEmployee)

        // WHEN the searchBar is closed AFTER filtering and selecting an employee from the filtered list
        viewModel.beginSearching(false)
        viewModel.updateSearchTerm("")
        let (nextUndefinedIndex, unselectedFilterEmployee) = viewModel.selectEmployee(index: -2)
        // THEN unselect still works as expected, returning -1, no matter the number unused to cause an unselection
        XCTAssertEqual(nextUndefinedIndex, -1)
        XCTAssertEqual(unselectedFilterEmployee, nil) // AND nil still returned to indicate no employee found
        XCTAssertEqual(unselectedFilterEmployee, viewModel.selectedEmployee) // AND viewModel's selectedEmployee returned to nil
        // AND Done button disabled
    }
}
