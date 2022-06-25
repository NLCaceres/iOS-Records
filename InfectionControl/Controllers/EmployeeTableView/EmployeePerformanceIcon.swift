//
//  EmployeePerformanceIcon.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct EmployeePoorPerformanceIcon: View {
    var body: some View {
        ZStack {
            XShape().stroke(.white, style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .frame(width: 20, height: 20)
        }.frame(width: 30, height: 30).background(.red).cornerRadius(8)
    }
}
struct EmployeeConcerningPerformanceIcon: View {
    var body: some View {
        let mustardYellow = Color(UIColor(rgb: 0xE1AD01))
        let grayBlack = Color(UIColor(argb: 0xC5000000)) // Goal: Slightly grayish black
        ZStack {
            WarningSign()
                .fill(grayBlack)
                .frame(width: 20, height: 25)
        }.frame(width: 30, height: 30).background(mustardYellow).cornerRadius(8)
    }
}
struct EmployeeGoodPerformanceIcon: View {
    var body: some View {
        ZStack {
            CheckMark()
                .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .bevel))
                .frame(width: 20, height: 25)
        }.frame(width: 30, height: 30).background(.green).cornerRadius(6)
    }
}


struct EmployeePerformanceIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmployeeGoodPerformanceIcon()
            EmployeeConcerningPerformanceIcon()
            EmployeePoorPerformanceIcon()
        }.previewLayout(.fixed(width: 350, height: 70))
    }
}
