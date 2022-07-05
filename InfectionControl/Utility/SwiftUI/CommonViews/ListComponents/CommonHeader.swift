//
//  CommonHeader.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

/* Basic Header to use across lists to style app-wide */
struct CommonHeader: View, BaseStyling {
    var title: String
    
    var body: some View {
        HStack {
            Text(title).font(.title2).fontWeight(.bold)
                .foregroundColor(self.themeColor.color)
                .padding(.init(top: 8, leading: 20, bottom: 5, trailing: 0))
            Spacer()
        }.background(self.themeSecondaryColor.color)
    }
}

struct CommonHeader_Previews: PreviewProvider {
    static var previews: some View {
        CommonHeader(title: "Hello World!").previewLayout(.fixed(width: 350, height: 75))
    }
}
