//
//  EmployeeRow.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct EmployeeRow: View {
    var employee: Employee
    var reportCount: Int = 0
    var professionString: String {
        if let profession = self.employee.profession { return profession.description }
        else { return "Profession info missing!" }
    }
    
    var body: some View {
        CommonRowRightSubtitle(title: "\(self.employee.firstName) \(self.employee.surname)", subtitleContent: {
            Text(professionString).font(.subheadline).foregroundStyle(UIColor.black.withAlphaComponent(0.7).color)
                .frame(minWidth: 30)

            if (reportCount > 5) { EmployeePoorPerformanceIcon() }
            else if (reportCount > 2) { EmployeeConcerningPerformanceIcon() }
            else { EmployeeGoodPerformanceIcon() }
        }).titleFont(.title3).subtitleFont(.subheadline).padding(.horizontal, 10)
    }
}


struct EmployeeRow_Previews: PreviewProvider {
    static var previews: some View {
        var employee = Employee(firstName: "John", surname: "Smith")
        employee.profession = Profession(observedOccupation: "Clinic", serviceDiscipline: "Physician")
        return Group {
            EmployeeRow(employee: employee)
            EmployeeRow(employee: Employee(firstName: "Anne", surname: "Katheway"))
        }.previewLayout(.fixed(width: 350, height: 70))
    }
}
