//
//  CreateReportCollectionView.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

// Could mark as final to prevent inheritance but probably not needed
class CreateReportCollectionView: UICollectionViewController {
    // MARK: Properties
    let precautionRepository: PrecautionRepository = AppPrecautionRepository()
    var precautions: [Precaution] = []
    var healthPractices: [HealthPractice] = []
    
    // MARK: IBOutlets
    var buttonImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UserDefaults.standard.color(forKey: "backgroundColor") // USC Light Gray
        self.collectionView.refreshControl = setUpRefreshControl(title: "Fetching Precaution Types",
                                                                 view: self, action: #selector(fetchPrecautionReportTypes))
        fetchPrecautionReportTypes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.collectionView.refreshControl?.endRefreshing()
        super.viewWillDisappear(animated)
    }
    
    @objc private func fetchPrecautionReportTypes() {
        Task {
            defer { // In case, guard-else clause causes an early return
                DispatchQueue.main.async { // Likely not long running so no capture list
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            precautions.removeAll()
            let newPrecautionList = try? await precautionRepository.getPrecautionList()
            guard let filledPrecautionList = newPrecautionList else { precautions = []; return }
            precautions.append(contentsOf: filledPrecautionList)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController else {
            print("Issue with the CreateReportCV Nav Controller embedding"); return
        }
        // After tapping the Precaution cell icon, prep to segue to CreateReportVC
        guard let clickedCell = sender as? MakeNewReportCell else { print("CreateReportCV segue received unexpected sender"); return }

        // TopViewController is the controller at the top of the stack, and PROBABLY being displayed
        // VisibleViewController, here, happens to be the same despite still being in prep to show CreateReportVC!
        // Likely a result of ".visibleViewcontroller" using ".topViewController" as a fallback
        guard let createReportController = navController.topViewController as? CreateReportViewController
        else { print("NavController didn't seem to add CreateReportViewController to the stack"); return }
        
        // Could also use "segue.identifier" as an extra check in case of multiple navigation paths
        let healthPractice = clickedCell.reportTypeLabel.text != nil ? HealthPractice(name: clickedCell.reportTypeLabel.text!) : nil
        createReportController.viewModel.reportHealthPractice = healthPractice
    }
    // Expected to unwind from CreateReportVC after successfully submitting new Report. Redirects to ReportTableView
    @IBAction func unwindHereAndSwitchTabs(sender: UIStoryboardSegue) {
        guard let tabBar = self.tabBarController else { print("Issue with CreateReportCV Tab Controller embedding"); return }
        // Could also use "tabBar.selectedIndex = 2" w/out the "if let" instead of ".selectedViewController"
        if let reportTableVC = tabBar.viewControllers?[2] {
            DispatchQueue.main.async { tabBar.selectedViewController = reportTableVC }
        }
    }
}
