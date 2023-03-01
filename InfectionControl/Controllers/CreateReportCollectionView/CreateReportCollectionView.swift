//
//  InfectionControlViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

// Could mark as final to prevent inheritance but probably not needed
class CreateReportCollectionView: UICollectionViewController {
    // Properties
    var networkManager: CompleteNetworkManager = NetworkManager()
    var precautions: [Precaution] = []
    var healthPractices: [HealthPractice] = []
    
    var buttonImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UserDefaults.standard.color(forKey: "backgroundColor") // USC Light Gray
        self.collectionView.refreshControl = setUpRefreshControl(title: "Fetching Report Types", view: self, action: #selector(fetchPrecautionReportTypes))
        fetchPrecautionReportTypes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.collectionView.refreshControl?.endRefreshing()
        super.viewWillDisappear(animated)
    }
    
    @objc private func fetchPrecautionReportTypes() {
        self.collectionView.refreshControl?.beginRefreshing()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let myVC = self else { return }
            myVC.networkManager.fetchTask(endpointPath: "precautions", updateClosure: myVC.updatePrecautions).resume()
        }
    }
    
    func updatePrecautions(data: Data?, err: Error?) {
        guard err == nil, let precautionData = data else { return }

        self.precautions.removeAll()
        if let decodedPrecautions = precautionData.toArray(containing: PrecautionDTO.self) {
            for decodedPrecaution in decodedPrecautions { self.precautions.append(decodedPrecaution.toBase()) }
        }
        
        DispatchQueue.main.async { // Likely not long running so no capture list
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
                let clickedCell = sender as? MakeNewReportCell
        else { print("Issue with the nav controller embedding"); return }
        
        guard let createReportController = navController.viewControllers.first as? CreateReportViewController,
            let reportLabel = clickedCell.reportTypeLabel.text
        else { print("Issue with new view controller"); return }
        
        createReportController.viewModel.reportHealthPractice = HealthPractice(name: reportLabel)
    }
    @IBAction func unwindHereAndSwitchTabs(sender: UIStoryboardSegue) {
        if let tabBar: UITabBarController = self.tabBarController {
            print("The tab bar has: \(tabBar.viewControllers?.count ?? 0) VCs")
            DispatchQueue.main.async { // Likely not long running so no capture list
                tabBar.selectedViewController = tabBar.viewControllers![2]
            }
        }
    }
}
