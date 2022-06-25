//
//  BaseStyling.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

protocol BaseStyling {
    var backgroundColor: UIColor { get }
    var themeColor: UIColor { get }
    var themeSecondaryColor: UIColor { get }
}

// MIGHT not be fast but useful and allows updates when settings mutates UserDefaults
extension BaseStyling {
    var backgroundColor: UIColor { UserDefaults.standard.color(forKey: "backgroundColor") ?? .white }
    var themeColor: UIColor { UserDefaults.standard.color(forKey: "themeColor") ?? .red }
    var themeSecondaryColor: UIColor { UserDefaults.standard.color(forKey: "themeSecondaryColor") ?? .yellow }
}

// MARK: Configure UIKit Views
func configureNavBar(themeColor: UIColor, themeSecondaryColor: UIColor) {
    let navBarAppearance = UINavigationBar.appearance()
    navBarAppearance.backgroundColor = themeColor
    navBarAppearance.barTintColor = themeColor
    // Following only works for inlineStyled navbar titles in SwiftUI
    navBarAppearance.titleTextAttributes = [.foregroundColor: themeSecondaryColor]
    // TintColor changes interactive elements of the nav
    navBarAppearance.tintColor = themeSecondaryColor.brighten(by: 0.07)
}
func configureSegmentedControl(themeColor: UIColor, themeSecondaryColor: UIColor) {
    let segmentedControlAppearance = UISegmentedControl.appearance()
    segmentedControlAppearance.selectedSegmentTintColor = themeSecondaryColor
    segmentedControlAppearance.backgroundColor = themeColor.brighten(by: 0.1)
    segmentedControlAppearance.setTitleTextAttributes([.foregroundColor: themeColor], for: .selected)
    segmentedControlAppearance.setTitleTextAttributes([.foregroundColor: themeSecondaryColor], for: .normal)
}
func configureRefreshControl(themeColor: UIColor) {
    let refreshControlAppearance = UIRefreshControl.appearance()
    refreshControlAppearance.tintColor = themeColor
}
