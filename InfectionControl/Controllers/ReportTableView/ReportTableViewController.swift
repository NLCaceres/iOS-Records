//
//  ReportTableViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit
import RxSwift
import SwiftUI

/* Fairly simple list of the latest reports. Should be clickable to perform segue to detailView */
//TODO: DetailViewController displaying similar details but further insight like reportedBy, assessedBy, etc.
class ReportTableViewController: UIViewController, BaseStyling {
    
    // Must use UIViewController as parent & make a tableView prop. Otherwise RxCocoa can't set/make the tableView delegate
    @IBOutlet var tableView: UITableView!
    
    // MARK: Properties
    let viewModel: ReportTableViewModel = ReportTableViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Styling
        self.tableView.refreshControl = setUpRefreshControl(title: "Fetching Reports", view: self, action: #selector(fetchReports))
        
        self.tableView.backgroundColor = self.backgroundColor
        self.tableView.separatorColor = self.themeColor
        
        bindViewModel()
        self.fetchReports()
        // ModelSelected is similar to ItemSelected which is just TableView Delegate's didSelectRow under the hood
        self.tableView.rx.modelSelected(ReportTableCellViewModel.self).subscribe(onNext: { [weak self] reportCell in
            print("Clicked a report cell! \(reportCell.report)")
            // Use following to send SwiftView into a faux HostingController in our navController and display it!
            let hostingController = UIHostingController(rootView: ReportDetailView())
            self?.navigationController?.pushViewController(hostingController, animated: true)
        }).disposed(by: disposeBag)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.refreshControl?.endRefreshing()
        super.viewWillDisappear(animated)
    }
    
    func bindViewModel() {
        // Setup tableView Delegate + DataSources (numRows + numSections taken care of instantly!)
        self.viewModel.reportCellViewModels.bind(to: self.tableView.rx.items) { tableView, index, viewModel in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as? ReportTableViewCell
            else {
                let errCell = UITableViewCell()
                errCell.isUserInteractionEnabled = false
                errCell.textLabel?.text = "Sorry! Seems we've run into an issue here. Please try again later!"
                return UITableViewCell()
            }
            cell.backgroundColor = self.backgroundColor
            cell.viewModel = viewModel
            return cell
        }.disposed(by: disposeBag)
        
        self.viewModel.isLoadingDisplay.subscribe(onNext: { [weak self] in self?.refreshLoading(loading: $0) },
                       onDisposed: { [weak self] in self?.refreshLoading(loading: false) }).disposed(by: disposeBag)
    }
    
    // Simple wrapper to prevent unrecognizedSelector issue (plus no need to mark viewModel or its func as @objc)
    @objc private func fetchReports() {
        self.tableView.refreshControl?.beginRefreshing()
        self.viewModel.getReports()
    }
    func refreshLoading(loading: Bool) {
        // Since RxSwift could run callbacks off the main thread, need to force it to since iOS DEMANDS UI updates be on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let refreshControl = self?.tableView.refreshControl else { return }
            // Since refresh starts w/out loading stream, check if it's already refreshing too! No need to double call
            loading && !refreshControl.isRefreshing ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        }
    }
}

struct ReportListViewController: UIViewControllerRepresentable {
    // Conforming to this protocol allows SwiftUI to display a view represented by typical UIKit UIViewControllers
    func makeUIViewController(context: Context) -> ReportTableViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ReportTableView") as? ReportTableViewController
        else { fatalError("ReportTableViewController seemingly not implemented in storyboard") }

        return viewController
    }

    func updateUIViewController(_ uiViewController: ReportTableViewController, context: Context) { } // Update code
}
