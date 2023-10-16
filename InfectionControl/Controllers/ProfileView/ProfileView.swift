//
//  ProfileView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI
import Kingfisher

struct ProfileView: View, BaseStyling {
    /* Why @StateObj? Because it's not destroyed on rerenders, letting you pass this single obj to children who observe/react to it
     * as an @ObservedObject. Children Views that receive @ObservedObjs this way can safely rerender without worrying about their
     * state resetting, which would occur if their parent also used @ObservedObj instead of @StateObj
     */
    @StateObject var viewModel: ProfileViewModel
    
    var employeeString: String {
        if let employee = self.viewModel.employee { return employee.fullName }
        else { return "Missing employee info" }
    }
    var employeeProfessionString: String {
        if let profession = self.viewModel.employee?.profession { return profession.description }
        else { return "Profession info missing!" }
    }
    /// May be able to use KFImage.placeholder(_ content:) instead of this computed @ViewBuilder prop. See "https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet"
    @ViewBuilder var EmployeeImgView: some View { // @ViewBuilder required since the implicit returns aren't the same exact type
        // resizable() is ONLY available on Images, so add it here, THEN returning the opaque "some View", we can apply the common modifiers inline
        if let employeeImgURL = viewModel.employeeImgURL {
            KFImage(employeeImgURL).resizable()
        }
        else {
            Image("mask").resizable()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    EmployeeImgView.scaledToFit()
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
