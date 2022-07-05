//
//  NavigableRow.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

// Creates a row to use in a list that overlaps with the tappable navigationLink aspect of it
// Why bother? Better styling! It doesn't push your view aside or cause weird padding
// Note on Use: Destination is the default trailing closure except in 2nd init(destination:content:)
struct NavigableRow<Content: View, Destination: View>: View, BaseStyling {
    var content: Content
    var destination: Destination
    
    // Best to use @ViewBuilder for both params in case a random closure preferred over a pre-defined component
    init(@ViewBuilder content: () -> Content, @ViewBuilder destination: () -> Destination) {
        self.content = content()
        self.destination = destination()
    }
    init(destination: Destination, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.destination = destination
    }
    init(content: Content, destination: Destination) {
        self.content = content
        self.destination = destination
    }
    
    var body: some View {
        ZStack { // Keeps Row from shrinking but still allows navLinking
            NavigationLink(destination: destination) {
                Rectangle().opacity(0.0)
                Spacer()
            }
            content
        }.listRowInsets(3, 0, 3, 10)
    }
}

struct NavigableRow_Previews: PreviewProvider {
    static var previews: some View {
        let report = Report(employee: Employee(firstName: "John", surname: "Smith"),
                            healthPractice: HealthPractice(name: "Healthpractice Name"),
                            location: Location(facilityName: "Name", unitNum: "1", roomNum: "2"),
                            date: Date())
        Group {
            // Double trailing closure style! (Could have written it NavigableRow(content:) {})
            NavigableRow {
                Text("Boom")
            } destination: {
                Text("Goodbye World!")
            }
            // 2nd init style with row content in trailing closure and simple destination component call as 1st param
            NavigableRow(destination: ReportDetailView()) {
                Text("Hello!")
            }
            
            // Simple component inits as params (great for passing in params to the inits!)
            NavigableRow(content: ReportRow(report: report), destination: ReportDetailView())
            
        }.previewLayout(.fixed(width: 350, height: 100))
    }
}
