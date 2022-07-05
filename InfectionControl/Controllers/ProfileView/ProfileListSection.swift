//
//  ProfileListSection.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ProfileListSection: View, BaseStyling {
    @ObservedObject var viewModel: ProfileViewModel
    func isTeamLeader(_ profession: Profession?) -> Bool {
        guard let profession = profession else { return false }
        return profession.serviceDiscipline.hasSuffix("Manager") ||
            profession.serviceDiscipline.hasSuffix("Supervisor")
    }
    
    var body: some View {
        if (isTeamLeader(viewModel.employee?.profession)) { SegmentedLists(viewModel: viewModel) }
        else {
            ReportListView(reportList: viewModel.reportList, refreshTask: { await viewModel.fetchReports() })
                .padding(.top, 5)
                .addNetworkIndicator(isRefreshing: viewModel.isLoadingReportList,
                                     title: "Loading Reports Data", color: themeColor.color)
                .task { if viewModel.reportList.isEmpty {
                    print("Empty reportLists, let's init them")
                    await viewModel.fetchReports()
                }}
        }
    }
}

struct SegmentedLists: View, BaseStyling {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var segment = 0
    
    var body: some View {
        VStack(spacing: 1) {
            Picker("Team List Picker", selection: self.$segment) { // Currently limited in styling
                Text("Team Roster").tag(0)
                Text("Recent Report Activity").tag(1)
            }.pickerStyle(.segmented) // BUT UISegmentedControl.appearance() DOES work!
            
            if segment == 0 {
                EmployeeListView(employeeList: self.viewModel.teamList, refreshTask: { await viewModel.fetchTeam() })
                    .addNetworkIndicator(isRefreshing: viewModel.isLoadingTeamList,
                                         title: "Loading Team Data", color: themeColor.color)
                    .task { if viewModel.teamList.isEmpty {
                        print("Empty teamList so init it")
                        await viewModel.fetchTeam()
                    }}
            }
            else if segment == 1 {
                ReportListView(reportList: self.viewModel.reportList, refreshTask: { await viewModel.fetchReports() })
                    .addNetworkIndicator(isRefreshing: viewModel.isLoadingReportList,
                                         title: "Loading Team Report Data", color: themeColor.color)
                    .task { if viewModel.reportList.isEmpty {
                        print("Empty reportList so init it")
                        await viewModel.fetchReports()
                    }}
            }
        }
    }
}

struct ProfileListSection_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        profileViewModel.employee = Employee(firstName: "John", surname: "Smith")
        profileViewModel.employee!.profession = Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")
        profileViewModel.reportList = [ReportRow_Previews.makeReport(), ReportRow_Previews.makeReport()]
        
        return ProfileListSection(viewModel: profileViewModel).previewInterfaceOrientation(.portrait)
    }
}
