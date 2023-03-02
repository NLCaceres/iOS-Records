//
//  EmployeeListViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest
import Combine

final class EmployeeListViewModelTests: XCTestCase {
    func testEmployeeListFetchAndLoad() async throws {
        var cancellables = Set<AnyCancellable>()
        let mockEmployeeList = [Employee(firstName: "John", surname: "Smith"), Employee(firstName: "Melody", surname: "Rios")]
        let mockRepository = MockEmployeeRepository(employeeList: mockEmployeeList)
        let employeeListViewModel = EmployeeListViewModel(employeeRepository: mockRepository)
        
        var times = 0
        employeeListViewModel.$isLoading.sink { // Monitor isLoading values as fetch called -F--T--F-->
            (times % 2 == 0) ? XCTAssertFalse($0) : XCTAssertTrue($0)
            times += 1
        }.store(in: &cancellables)
        
        XCTAssertEqual(employeeListViewModel.employeeList, []) // Starts as empty list
        await employeeListViewModel.getEmployeeList() // Now should update value to repository's value
        XCTAssertEqual(mockEmployeeList, employeeListViewModel.employeeList) // Updated to expected mockList
    }
    func testGetSingleEmployee() async throws {
        let mockEmployeeList = [ // Profession prop must not be nil or filtering fails. Unlikely to change since real JSON should always have profession
            Employee(firstName: "John", surname: "Smith", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
            Employee(firstName: "Melody", surname: "Rios", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor"))]
        let mockRepository = MockEmployeeRepository(employeeList: mockEmployeeList)
        let employeeListViewModel = EmployeeListViewModel(employeeRepository: mockRepository)
        
        await employeeListViewModel.getEmployeeList() // Populate the list
        let employee = employeeListViewModel.getEmployee(index: 1) // Get employee at row 2 (Counting from 1)
        XCTAssertEqual(employee.fullName, "Melody Rios")
        
        employeeListViewModel.searchBarOpen = true // Open the search bar
        employeeListViewModel.filterEmployeeList(searchTerm: "Smith") // Filter the employee list
        let filteredEmployee = employeeListViewModel.getEmployee(index: 0) // Get employee from filtered ListView at 1st row
        XCTAssertEqual(filteredEmployee.fullName, "John Smith")
    }
    func testFilteringEmployees() async throws {
        let mockEmployeeList = [ // Profession must not be nil or filtering fails. Unlikely to change since real JSON should always have profession
            Employee(firstName: "John", surname: "Smith", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
            Employee(firstName: "Melody", surname: "Rios", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor"))]
        let mockRepository = MockEmployeeRepository(employeeList: mockEmployeeList)
        let employeeListViewModel = EmployeeListViewModel(employeeRepository: mockRepository)
        
        await employeeListViewModel.getEmployeeList() // Populate the list
        employeeListViewModel.searchBarOpen = true // Open the search bar
        employeeListViewModel.filterEmployeeList(searchTerm: "Smith") // Filter the employee list
        XCTAssertEqual(employeeListViewModel.filteredEmployeeList.count, 1)
        XCTAssertEqual(employeeListViewModel.filteredEmployeeList[0].fullName, "John Smith")
    }
    func testFilteringBegan() throws {
        let mockRepository = MockEmployeeRepository(employeeList: [])
        let employeeListViewModel = EmployeeListViewModel(employeeRepository: mockRepository)
        XCTAssertFalse(employeeListViewModel.filteringBegan()) // Defaults to false (since searchBar is closed + searchTerm is empty)
        
        employeeListViewModel.searchBarOpen = true
        XCTAssertFalse(employeeListViewModel.filteringBegan()) // Still false since searchBar opened but searchTerm still empty
        
        employeeListViewModel.filterEmployeeList(searchTerm: "Foobar")
        XCTAssertTrue(employeeListViewModel.filteringBegan()) // Should be true since searchBar open AND search term updated to non-empty string
    }
    func testSelectEmployee() async throws {
        var cancellables = Set<AnyCancellable>()
        let mockEmployeeList = [ // ID must not be nil because selectedEmployee's index is determined by ID, just like in real JSON data
            Employee(id: "0", firstName: "John", surname: "Smith", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")),
            Employee(id: "1", firstName: "Melody", surname: "Rios", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Doctor"))]
        let mockRepository = MockEmployeeRepository(employeeList: mockEmployeeList)
        let employeeListViewModel = EmployeeListViewModel(employeeRepository: mockRepository)
        
        var times = 0 // DoneButton also is disabled based on selectedEmployee, defaulting to false (so disabled)
        employeeListViewModel.doneButtonEnabled.sink { // --F--T-F-T-F-->
            (times % 2 == 0) ? XCTAssertFalse($0) : XCTAssertTrue($0)
            times += 1
        }.store(in: &cancellables)
        await employeeListViewModel.getEmployeeList() // Populate the list
        let (index, employee) = employeeListViewModel.selectEmployee(index: 1) // Get employee at row 2 (indexed to 0)
        XCTAssertEqual(employee!.fullName, "Melody Rios"); XCTAssertEqual(index, 1)
        XCTAssertEqual(employee, employeeListViewModel.selectedEmployee)
        // Done button enabled now that employee has been SELECTED
        
        let (undefinedIndex, unselectedEmployee) = employeeListViewModel.selectEmployee(index: -1) // Unselect the employee
        XCTAssertEqual(unselectedEmployee, nil); XCTAssertEqual(undefinedIndex, -1)
        XCTAssertEqual(unselectedEmployee, employeeListViewModel.selectedEmployee)
        // Done button disabled now that employee has been UNSELECTED
        
        employeeListViewModel.searchBarOpen = true // Open the search bar
        employeeListViewModel.filterEmployeeList(searchTerm: "Smith") // Filter the employee list
        let (originalIndex, filteredEmployee) = employeeListViewModel.selectEmployee(index: 0) // Select employee at row 1 of filtered listView
        XCTAssertEqual(filteredEmployee!.fullName, "John Smith")
        XCTAssertEqual(originalIndex, 0) // Returns index from original employeeList, not the filteredList
        XCTAssertEqual(filteredEmployee, employeeListViewModel.selectedEmployee)
        // Done button enabled now that employee from filtered list has been SELECTED
        
        employeeListViewModel.searchBarOpen = false // Even if searchBar closed
        // And even if index provided is less than 0 or -1
        let (nextUndefinedIndex, unselectedFilterEmployee) = employeeListViewModel.selectEmployee(index: -2)
        XCTAssertEqual(unselectedFilterEmployee, nil) // THEN unselect and set back to nil
        XCTAssertEqual(nextUndefinedIndex, -1) // Returned -1 still to indicate unselect successful
        XCTAssertEqual(unselectedFilterEmployee, employeeListViewModel.selectedEmployee) // And viewModel's selectedEmployee returned to nil
        // Done button disabled now that employee from filtered list has been UNSELECTED
    }
}
