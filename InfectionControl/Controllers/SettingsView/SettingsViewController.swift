//
//  SettingsTableViewController.swift
//  InfectionControl
//
//  Copyright © 2019 Nick Caceres. All rights reserved.

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    private var viewModel = ProfileViewModel()
    private lazy var hostVC = makeHostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Following = useful pattern for combining/reusing views
        addChild(hostVC)
        view.addSubview(hostVC.view)
        hostVC.didMove(toParent: self) // Notify hostVC, setup is done
        
        NSLayoutConstraint.activate([
            hostVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostVC.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Produces a hostingController to put our SwiftUI view in
    private func makeHostViewController() -> UIHostingController<SettingsView> {
        let settingsView = SettingsView()
        let hostVC = UIHostingController(rootView: settingsView)
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false
        return hostVC
    }
}
