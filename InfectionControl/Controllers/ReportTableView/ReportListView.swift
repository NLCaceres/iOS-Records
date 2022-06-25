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
                ForEach(self.reportList, id: \.id) { report in
                    ZStack { // Keeps Row from shrinking but still allows navLinking
                        NavigationLink(destination: ReportDetailView()) {
                            Rectangle().opacity(0.0)
                            Spacer()
                        }
                        ReportRow(report: report)
                    }
                    .listRowInsets(.init(top: 3, leading: 0, bottom: 3, trailing: 10))
                }.listRowSeparatorTint(.red)
            }
            header: {
                HStack {
                    Text(headerText).font(.title2)
                        .fontWeight(.bold).foregroundColor(self.themeColor.color)
                        .padding(.init(top: 8, leading: 20, bottom: 5, trailing: 0))
                    Spacer()
                }.background(self.themeSecondaryColor.color)
            }.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
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
