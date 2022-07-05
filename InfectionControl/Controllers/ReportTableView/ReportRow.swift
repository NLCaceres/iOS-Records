//
//  ReportRow.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ReportRow: View {
    var report: Report
    var violationString: String { "\(self.report.healthPractice.name) Violation" }
    var employeeString: String { "Committed by \(self.report.employee.fullName)" }
    var employeeProfessionString: String { self.report.location.description }

    var body: some View {
        CommonRowSubtitled(imageName: "report_placeholder_icon") {
            Text(violationString).font(.headline)
            Text(employeeString).font(.body).padding(.leading, 7)
            Text(employeeProfessionString).font(.body).padding(.leading, 7)
        }
    }
}

struct ReportRow_Previews: PreviewProvider {
    static var previews: some View {
        ReportRow(report: makeReport()).previewLayout(.fixed(width: 350, height: 100))
    }
    static func makeReport() -> Report {
        let employee = Employee(firstName: "John", surname: "Smith", profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Physician"))
        let healthPractice = HealthPractice(name: "Hand Hygiene", precautionType: Precaution(name: "Violation"))
        let location = Location(facilityName: "USC", unitNum: "1", roomNum: "2")
        return Report(employee: employee, healthPractice: healthPractice, location: location, date: Date())
    }
}
