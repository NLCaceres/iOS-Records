//
//  EmployeeListView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct EmployeeListView: View, BaseStyling {
    var employeeList: [Employee]
    var refreshTask: () async -> ()
    
    var body: some View {
        List {
            Section {
                ForEach(self.employeeList) { employee in
                    EmployeeRow(employee: employee).listRowInsets(15, 10, 5, 10)
                }.listRowSeparatorTint(.red)
            } // Rather than a simple header, a nice reusable custom one!
            header: { CommonHeader(title: "Team List") }.flushListRow()
            
            .listRowBackground(self.backgroundColor.withAlphaComponent(0.5).color)
        }.listStyle(.grouped).refreshable {
            print("Running a employeeList refresher!")
            Task { @MainActor in await refreshTask() }
        }
    }
}


struct EmployeeListView_Previews: PreviewProvider {
    static var previews: some View {
        let otherEmployee = Employee(firstName: "Maria", surname: "Garcia", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse"))
        let employeeList = [otherEmployee, otherEmployee, otherEmployee]
        return EmployeeListView(employeeList: employeeList, refreshTask: {})
    }
}
