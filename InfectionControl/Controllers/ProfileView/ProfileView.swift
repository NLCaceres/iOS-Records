//
//  ProfileView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ProfileView: View, BaseStyling {
    /* Why @StateObj? It's not destroyed on rerenders! Letting you pass this single obj to children who observe/react to it
     as an @ObservedObject
     @ObservedObject where the obj must be marked as @ObservedObj every time. BUT there's a way around
     the rerender erase. Pass the obj in from elsewhere! Meaning we're actually safe here since it comes from
     the parent VC BUT since we're passing the viewModel down, better to use @StateObj as intended/expected! */
    @StateObject var viewModel: ProfileViewModel
    
    var employeeString: String {
        if let employee = self.viewModel.employee { return employee.fullName }
        else { return "Missing employee info" }
    }
    var employeeProfessionString: String {
        if let profession = self.viewModel.employee?.profession { return profession.description }
        else { return "Profession info missing!" }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Image("mask").resizable().scaledToFit()
                        .frame(width: 140, height: 140, alignment: .leading)
                        .padding(.top, 10)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(employeeString).font(.title2)
                        Text(employeeProfessionString).font(.headline)
                            .foregroundColor(UIColor.black.withAlphaComponent(0.5).color)
                            .padding(.leading, 15)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 5).padding(.top, 5)
                }.addNetworkIndicator(isRefreshing: viewModel.isLoadingEmployee,
                                      title: "Loading your Employee Data", color: self.themeColor.color)
                
                ProfileListSection(viewModel: viewModel).onAppear { print("ProfileListSection appeared") }
                
            }.padding(.top, 5).background(self.backgroundColor.color)
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }.navigationViewStyle(.stack)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        let employee = Employee(firstName: "John", surname: "Smith")
        profileViewModel.employee = employee
        profileViewModel.employee!.profession = Profession(observedOccupation: "Clinic", serviceDiscipline: "Nurse")
        profileViewModel.reportList = [ReportRow_Previews.makeReport(), ReportRow_Previews.makeReport()]
        
        let secondProfileViewModel = ProfileViewModel()
        secondProfileViewModel.reportList = []
        
        let otherProfileViewModel = ProfileViewModel()
        let otherEmployee = Employee(firstName: "Maria", surname: "Garcia",
                                     profession: Profession(observedOccupation: "Clinic", serviceDiscipline: "Supervisor"))
        otherProfileViewModel.employee = otherEmployee
        otherProfileViewModel.reportList = [ReportRow_Previews.makeReport(), ReportRow_Previews.makeReport()]
        otherProfileViewModel.teamList = [employee, employee, employee]
        
        return Group {
            ProfileView(viewModel: profileViewModel) // Typical employee view
            ProfileView(viewModel: secondProfileViewModel) // Loading info example
            ProfileView(viewModel: otherProfileViewModel) // Supervisor view with segmented control lists
        }.previewInterfaceOrientation(.portrait)
    }
}
