//
//  SettingsView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct SettingsView: View {
    @State private var preferSystemAppearance = false // If true, allow system to decide backgroundColor / fontColor
    var isDarkMode: Bool { UITraitCollection.current.userInterfaceStyle == .dark }
    @State private var backgroundColor =
        UserDefaults.standard.color(forKey: "backgroundColor")?.color ?? UIColor.gray.color
    @State private var themeColor =
        UserDefaults.standard.color(forKey: "themeColor")?.color ?? UIColor.red.color
    @State private var themeSecondaryColor =
        UserDefaults.standard.color(forKey: "themeSecondary")?.color ?? UIColor.yellow.color
    
    @State private var concerningNumReports = 3
    @State private var poorNumReports = 6
    
    var body: some View { // Body only returns one view! so probably a H,V, or Z stack
        List {
            Section("Colors") {
                Toggle("Prefer to Use System Light and Dark Mode?", isOn: $preferSystemAppearance)
                    .toggleStyle(.switch).tint(themeColor)
                if !preferSystemAppearance {
                    ColorPicker(selection: $backgroundColor) {
                        Text("Background Color")
                        /* TODO: Could extend Binding creating an onChange func to be called on
                         $backgroundColor directly above. That func would return a Binding with
                         a set param closure to call a passed in handler! */
                    }.onChange(of: backgroundColor) { print("backgroundColor changed to \($0)") }
                }
                
                ColorPicker("Theme Color", selection: $themeColor).onChange(of: themeColor) { newColor in
                    print("Color Changed: \(newColor)")
                }
                
                ColorPicker("Theme Secondary Color", selection: $themeSecondaryColor)
                    .onChange(of: themeSecondaryColor) { print ("themeSecondaryColor changed to \($0)") }
            }.listRowBackground(Color.white).listRowSeparatorTint(.black)
            
            Section("Organization") {
                Text("University of Southern California").disabled(true)
            }.listRowBackground(Color.white)
            
            Section("Performance Indicators") {
                // TODO: Update labels. For custom steppers would need to make a full custom view.
                Stepper("Number of Reports to Cause Concern: \(concerningNumReports)", value: $concerningNumReports)
                Stepper("Number of Reports to Force Action: \(poorNumReports)", value: $poorNumReports)
            }.listRowBackground(Color.white)
            
        }.listStyle(.insetGrouped)
        .onAppear {
            print("Dark mode is on: \(isDarkMode)")
            UITableView.appearance().separatorInsetReference = .fromCellEdges
            UITableView.appearance().backgroundColor = UIColor(self.backgroundColor)
            
        }
        /* Both onAppear + onDisappear fires when tab change; HOWEVER, only this list changes,
         using onDisappear to reset changes causes future onAppears to not change this inset back */
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
