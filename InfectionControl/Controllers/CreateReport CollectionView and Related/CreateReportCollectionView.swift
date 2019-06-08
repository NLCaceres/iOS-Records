//
//  InfectionControlViewController.swift
//  InfectionControl
//
//  Created by Nick Caceres on 4/2/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

// I could mark it final to prevent inheritance but probably not necessary
class CreateReportCollectionView: UICollectionViewController {
    // Properties
    let segueIdentifier = "CreateReportSegue"
    let reuseIdentifier = "ReportCreaterCell"
    private let sectionInsets = UIEdgeInsets(top: 25.0,
                                             left: 50.0,
                                             bottom: 25.0,
                                             right: 50.0)
    private let itemsPerRow: CGFloat = 2

    // Just like Javascript, except let is immutable
    // Watch for mutable vs immutable classes
    var precautions: [Precaution] = []
    var healthPractices: [HealthPractice] = []
    
    // I could create this URLSession
    // But since I am using the default config anyway, better to use the singleton
    // URLSession.shared.DATATASKOBJ
    private let urlSession = URLSession(configuration: .default)
    //private let precautionEndpoint: URL! = URL(string: "https://safe-retreat-87739.herokuapp.com/api/precautions")
    private let mockPrecautionEndpoint: URL! = URL(string: "http://127.0.0.1:3000/api/precautions")
    
    var buttonImage: UIImage?
    @IBAction func unwindHereAndSwitchTabs(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateReportViewController, let newReport = sourceViewController.fullReport {
            print("Got the full report: \(newReport)")
            if let tabBar: UITabBarController = self.tabBarController {
                print("The Tab bar does exist!")
                print("The tab bar has: \(tabBar.viewControllers!)")
                DispatchQueue.main.async {
                    tabBar.selectedViewController = tabBar.viewControllers![2]
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Not necessary to register if you're customizing cells (meaning you'll register things later)
        //self.collectionView!.register(ReportCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register refresh control (iOS already enables collection/table views to have them)
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = setUpRefreshControl()
        } else {
            self.collectionView.addSubview(setUpRefreshControl())
        }
        
        fetchReportTypes()
        fetchButtonImage()
        
    }
    
    func setUpRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchReportTypes(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Report Types")
        return refreshControl
    }
    
    @objc private func fetchReportTypes(_ sender: Any? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            let fetchJSONTask = DataHandler.fetchTaskCreater(self.mockPrecautionEndpoint, self.updatePrecautions)
            fetchJSONTask.resume()
            
        }
    }
    
    func updatePrecautions(data: Data) {
        do {
            self.precautions.removeAll()
            
            let jsonDecoder = JSONDecoder()
            let decodedPrecautions = try jsonDecoder.decode([Precaution].self, from: data)
            for decodedPrecaution in decodedPrecautions {
                print("This is the decoded precaution we're working on: \(decodedPrecaution)")
                self.precautions.append(decodedPrecaution)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
            
        } catch let error {
            print("Precautions update error: \(error)")
        }
        
        // WITHOUT CODABLE IT WOULD LOOK A LOT WORSE and be more difficult of course
        //    let json = try JSONSerialization.jsonObject(with: data, options: [])
        //    guard let jsonArr = json as? [[String:Any]] else {
        //         return
        //    }
        //    print("This is the JSON returned: \(json)")
        //    print("This is the JSON array: \(jsonArr)")
        //    for dict in jsonArr {
        //        guard let occupation = dict["observed_occupation"] as? String else {
        //              print("occupation conversion error")
        //              return
        //        }
        //        print("Observed Occupation: \(occupation)")
        //        guard let discipline = dict["service_discipline"] as? String else {
        //              print("discipline conversion error")
        //              return
        //        }
        //        print("Service Discipline: \(discipline)")
        //        guard let label = dict["label"] as? String else {
        //              print("Label conversion error")
        //              return
        //        }
        //        let newProfession = Profession(observedOccupation: occupation, serviceDiscipline: discipline)
        //              self.professions.append(newProfession)
        //              print("Label: \(label)")
        //        }
    }
    
    func fetchButtonImage() {
        let imageURL = URL(string: "https://cdn1.iconfinder.com/data/icons/ui-colored-1/100/UI__2-512.png")
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            let imageFetchTask = URLSession.shared.dataTask(with: imageURL!) { data, response, error in
                if let error = error {
                    print("Found an error: \(error.localizedDescription)" )
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Found an error related to status code")
                        return
                }
                if let data = data {
                    self.buttonImage = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            imageFetchTask.resume()
        }
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        guard let navController = segue.destination as? UINavigationController, let clickedCell = sender as? ReportCell
        else {
            print("Issue with the nav controller embedding")
            return
        }
        guard let createReportController = navController.viewControllers.first as? CreateReportViewController,
            let reportLabel = clickedCell.reportCellLabel.text
        else {
            print("Issue with new view controller")
            return
        }
        createReportController.viewModel.reportPracticeType = reportLabel
        
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - Collection View Flow Layout Delegate
// Proper way to use extensino
// Extends functions of our custom CollectionViewController
// Specifically the ViewDelegateFlowLayout
extension CreateReportCollectionView : UICollectionViewDelegateFlowLayout {
    // Layout size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Establishes padding (basic algebra in a sense)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Space between cell, top and bottom
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Space between each row of cells in a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }
}



