//
//  CommonStyling.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

/* Styling protocols that SwiftUI Struct Views can conform to.
 Their extensions define basic and very common function, written to be fluent like rest of SwiftUI */
protocol FontStyling { } // Abstract Parent that updates font in some way - style, weight, etc.
protocol TitleStyling: FontStyling {
    var titleFont: Font? { get set }
    func titleFont(_ font: Font?) -> Self
}
extension TitleStyling {
    // No need for 'mutating' just leverage structs as value types!
    func titleFont(_ font: Font?) -> Self {
        var newView = self // Whole new value
        newView.titleFont = font // Change prop so newly styled view can be returned (AND chained to other style changes)
        return newView
    }
}
protocol SubtitleStyling: FontStyling {
    var subtitleFont: Font? { get set }
    func subtitleFont(_ font: Font?) -> Self
}
extension SubtitleStyling {
    func subtitleFont(_ font: Font?) -> Self {
        var newView = self
        newView.subtitleFont = font
        return newView
    }
}
protocol FullTitleStyling: TitleStyling, SubtitleStyling {}
