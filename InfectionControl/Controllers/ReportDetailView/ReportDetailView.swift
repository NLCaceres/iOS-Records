//
//  ReportDetailView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct ReportDetailView: View, BaseStyling {
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .top) {
                Text("Hello!")
                Spacer()
            }
            Spacer()
        }.background(self.backgroundColor.color)
    }
}

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReportDetailView()
    }
}
