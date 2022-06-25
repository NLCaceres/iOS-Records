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
        guard let profession = self.employee.profession else {
            return "Profession info missing"
        }
        return "\(profession.observedOccupation) \(profession.serviceDiscipline)"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(self.employee.firstName) \(self.employee.surname)").font(.headline)
                .frame(minWidth: 30).lineLimit(1)
            Spacer() // Automatically expands across parent view
            Text(professionString).font(.subheadline).foregroundStyle(UIColor.black.withAlphaComponent(0.7).color)
                .frame(minWidth: 30).lineLimit(1)
            
            if (reportCount > 5) { EmployeePoorPerformanceIcon() }
            else if (reportCount > 2) { EmployeeConcerningPerformanceIcon() }
            else { EmployeeGoodPerformanceIcon() }
        }.padding(.horizontal, 10)
    }
}


struct EmployeeRow_Previews: PreviewProvider {
    static var previews: some View {
        var employee = Employee(firstName: "John", surname: "Smith")
        employee.profession = Profession(observedOccupation: "Clinic", serviceDiscipline: "Physician")
        return EmployeeRow(employee: employee).previewLayout(.fixed(width: 350, height: 70))
    }
}
