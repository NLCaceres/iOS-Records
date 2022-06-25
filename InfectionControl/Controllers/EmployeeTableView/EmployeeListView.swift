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
                ForEach(self.employeeList, id: \.id) { employee in
                    EmployeeRow(employee: employee)
                        .listRowInsets(.init(top: 15, leading: 10, bottom: 5, trailing: 10))
                }.listRowSeparatorTint(.red)
            }
            header: { // Override default styling of header's simple Text()
                HStack {
                    Text("Team List").font(.title2).fontWeight(.bold)
                        .foregroundColor(self.themeColor.color)
                        .padding(.init(top: 8, leading: 20, bottom: 5, trailing: 0))
                    Spacer()
                }.background(self.themeSecondaryColor.color)
            }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
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
