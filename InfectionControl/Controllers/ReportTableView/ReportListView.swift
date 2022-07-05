//
//  ReportListView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ReportListView: View, BaseStyling {
    var reportList: [Report]
    var headerText: String = "Recent Reports"
    var refreshTask: () async -> ()
    
    var body: some View {
        List {
            Section {
                ForEach(self.reportList) { report in
                    NavigableRow(content: ReportRow(report: report), destination: ReportDetailView())
                }.listRowSeparatorTint(.red)
            }
            header: { CommonHeader(title: headerText) }.flushListRow()
            
            .listRowBackground(self.backgroundColor.withAlphaComponent(0.5).color)
        }.listStyle(.grouped).onAppear {
            UITableView.appearance().backgroundColor = self.backgroundColor.withAlphaComponent(0.5)
        }
        .refreshable {
            print("Running the report list refresher!")
            Task { @MainActor in await refreshTask() }
        }//.animation(.easeIn, value: reportList)
    }
}

struct ReportListView_Previews: PreviewProvider {
    static var previews: some View {
        let reportList = [ReportRow_Previews.makeReport(), ReportRow_Previews.makeReport()]
        ForEach(["iPhone SE (2nd generation)", "iPhone 13 Pro Max"], id: \.self) { deviceName in
            ReportListView(reportList: reportList, headerText: "Reports Concerning Team", refreshTask: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
