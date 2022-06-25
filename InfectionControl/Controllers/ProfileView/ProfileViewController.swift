//
//  ProfileViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    private var viewModel = ProfileViewModel()
    private lazy var hostVC = makeHostViewController()
    
    override func viewDidLoad() {
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
        // Why weak? The VC may die, leaving the viewModel nil in a sense! even if not an optional but risk fatal err using unowned...
        // But hmm... it should run immediately, unlike a callback getting called later when a VC may actually have died
        Task { [weak viewModel] in await viewModel?.fetchEmployeeInfo() }
    }
    // Produces a hostingController to put our SwiftUI view in 
    private func makeHostViewController() -> UIHostingController<ProfileView> {
        let profileView = ProfileView(viewModel: self.viewModel)
        let hostVC = UIHostingController(rootView: profileView)
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false
        return hostVC
    }
}
