//
//  TabBarConfig.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import UIKit

// MARK: Configure TabBar
func configureTabBar(_ tabBarController: UITabBarController) {
    tabBarController.selectedIndex = 1
    
    if #available(iOS 15, *) { updateTabBarAppearance(tabBarController) }
    else { oldUpdateTabBarAppearance() }
}
@available(iOS 15.0, *)
private func updateTabBarAppearance(_ tabBarController: UITabBarController) {
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithOpaqueBackground()
    
    let barTintColor = UserDefaults.standard.color(forKey: "themeColor") ?? .red
    tabBarAppearance.backgroundColor = barTintColor
    
    updateTabBarItemAppearance(appearance: tabBarAppearance.stackedLayoutAppearance) // Portrait mode
    updateTabBarItemAppearance(appearance: tabBarAppearance.inlineLayoutAppearance) // Landscape mode
    updateTabBarItemAppearance(appearance: tabBarAppearance.compactInlineLayoutAppearance) // Unsure where used???
    
    tabBarController.tabBar.standardAppearance = tabBarAppearance
    tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance // New API that should be set and should match standard
}
@available(iOS 13.0, *)
private func updateTabBarItemAppearance(appearance: UITabBarItemAppearance) {
    let unselectedItemTintColor: UIColor = .white //TODO: Font color default?
    let selectedTintColor: UIColor = UserDefaults.standard.color(forKey: "themeSecondaryColor") ?? .yellow
    
    appearance.normal.iconColor = unselectedItemTintColor
    appearance.normal.titleTextAttributes = [.foregroundColor: selectedTintColor]
    
    appearance.selected.iconColor = selectedTintColor
    appearance.selected.titleTextAttributes = [.foregroundColor: unselectedItemTintColor]
}
private func oldUpdateTabBarAppearance() {
    UITabBar.appearance().barTintColor = UserDefaults.standard.color(forKey: "themeColor") ?? .red
    UITabBar.appearance().isTranslucent = false // Slightly brightens color (e.g. not as dark red)
    
    let unselectedItemTintColor: UIColor = .white //TODO: Font color default?
    let selectedTintColor: UIColor = UserDefaults.standard.color(forKey: "themeSecondaryColor") ?? .yellow
    
    // Selected barItem colors
    UITabBar.appearance().unselectedItemTintColor = unselectedItemTintColor
    UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : selectedTintColor], for: .normal)
    
    // Unselected/Normal barItem colors
    UITabBar.appearance().tintColor = selectedTintColor
    UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : unselectedItemTintColor], for: .selected)
}
