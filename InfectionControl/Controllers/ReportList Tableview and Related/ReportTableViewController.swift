//
//  ReportTableViewController.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/7/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {
    
    private var reports: [Report] = []
    //private let endpoint = URL(string: "https://safe-retreat-87739.herokuapp.com/api/reports")
    //private let urlSession = URLSession(configuration: .default)
    
    private let reuseIdentifier = "ReportTableViewCell"
    
    @objc dynamic private var viewModel: ReportTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ReportTableViewModel()
        
        if #available(iOS 10.0, *) {
            print("Running this since iOS 10+")
            self.tableView.refreshControl = setUpRefreshControl()
        } else {
            self.tableView.addSubview(setUpRefreshControl())
        }
        
        viewModel.fetchReports()
        addObserver(self, forKeyPath: #keyPath(viewModel.reportCells), options: [.old, .new], context: nil)
    }
    
    // Ignoring RxSwift, this actually works! But it requires a ton more code to get it properly functioning
    // Thankfully not as much as using a protocol and delegates might though
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(viewModel.reportCells) {
            // Update Table View
            DispatchQueue.main.async {
                print("Calling this to reload and end refresh")
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
//    func configureViews() {
//        setUpRefreshControl()
//    }
    
    func setUpRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchHelper(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.green
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Reports")
        return refreshControl
    }
    
    @objc private func fetchHelper(_ sender: Any) {
        print("Calling this from in ReportTable VC Helper")
        viewModel.fetchReports()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Number of sections (so one 1 since it's all reports
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of tableview rows
        //return viewModel.numOfCells
        print("Num of cells: \(viewModel.numOfCells)")
        return viewModel.numOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReportTableViewCell
        let reportCellData = viewModel.reportCellViewModel(at: indexPath.row)
        
        cell.reportTableCellImageView.image = reportCellData.image
        cell.reportTableCellMainLabel.attributedText = reportCellData.titleText
        cell.reportTableCellNameLabel.attributedText = reportCellData.nameText
        cell.reportTableCellLocation.attributedText = reportCellData.locationText
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
