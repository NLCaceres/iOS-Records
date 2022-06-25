//
//  ReportRow.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ReportRow: View {
    var report: Report
    var violationString: String {
        return "\(self.report.healthPractice.name) Violation"
    }
    var employeeString: String {
        return "Committed by \(self.report.employee.firstName) \(self.report.employee.surname)"
    }
    var employeeProfessionString: String {
        let facility = self.report.location.facilityName
        let unit = self.report.location.unitNum
        let room = self.report.location.roomNum
        
        return "Location: \(facility) Unit \(unit) Room \(room)"
    }
    var body: some View {
        HStack(alignment: .center) {
            Image("report_placeholder_icon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 6) {
                Text(violationString).font(.headline)
                Text(employeeString).font(.body).padding(.leading, 7)
                Text(employeeProfessionString).font(.body).padding(.leading, 7)
            }
            Spacer()
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
