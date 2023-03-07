//
//  ReportTableViewController.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

/* Fairly simple list of the latest reports. Should be clickable to perform segue to detailView */
class ReportTableViewController: UIViewController, BaseStyling {
    
    // Must use UIViewController as parent & set a UITableView prop. Otherwise RxCocoa can't set/make the tableView delegate
    @IBOutlet var tableView: UITableView!
    
    // MARK: Properties
    let viewModel: ReportTableViewModel = ReportTableViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Styling
        tableView.refreshControl = setUpRefreshControl(title: "Fetching Reports", view: self, action: #selector(getReportList))
        
        tableView.backgroundColor = self.backgroundColor
        tableView.separatorColor = self.themeColor
        
        bindViewModel()
        getReportList()
        // ModelSelected is similar to ItemSelected which is just TableView Delegate's didSelectRow under the hood
        tableView.rx.modelSelected(ReportTableCellViewModel.self).subscribe(onNext: { [weak self] reportCell in
            print("Clicked a report cell! \(reportCell.report)")
            // Use following to send the ReportDetail SwiftUI-based view into a HostingController so the parent navController of ReportTableView can display it
            let hostingController = UIHostingController(rootView: ReportDetailView())
            self?.navigationController?.pushViewController(hostingController, animated: true)
        }).disposed(by: disposeBag)
    }
    override func viewWillDisappear(_ animated: Bool) {
        tableView.refreshControl?.endRefreshing()
        super.viewWillDisappear(animated)
    }
    
    func bindViewModel() {
        // Setup tableView Delegate + DataSources (numRows + numSections taken care of instantly!)
        viewModel.reportCellViewModels.bind(to: self.tableView.rx.items) { tableView, index, viewModel in
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
        
        viewModel.isLoadingDisplay.subscribe(
            onNext: { [weak self] in self?.refreshLoading(loading: $0) },
            onDisposed: { [weak self] in self?.refreshLoading(loading: false) }
        ).disposed(by: disposeBag)
    }
    
    // Simple wrapper to prevent unrecognizedSelector issue (plus no need to mark viewModel or its func as @objc)
    @objc private func getReportList() {
        tableView.refreshControl?.beginRefreshing() // TODO: Still necessary? or simply allow isLoadingDisplay to beginRefresh()
        Task { await viewModel.getReportList() }
    }
    // Since the following func is fairly verbose, we can use it to DRY up isLoadingDisplay.subscribe()
    func refreshLoading(loading: Bool) { // Since RxSwift can run callbacks off the main thread, force it on the main thread via DispatchQueue.main
        DispatchQueue.main.async { [weak self] in // .async ensures this block gets called asap w/out any UI freezing
            guard let refreshControl = self?.tableView.refreshControl else { return } // Ensure view is alive and refreshControl available
            if (loading && !refreshControl.isRefreshing) { refreshControl.beginRefreshing() } // If in load state and not already refreshing, then start refresh
            else { refreshControl.endRefreshing() } // Else stop refreshControl
        }
    }
}

/* Conforming to this protocol allows SwiftUI to contain a view created/written in UIKit UIViewControllers */
struct ReportListViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ReportTableViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ReportTableView") as? ReportTableViewController
        else { fatalError("ReportTableViewController seemingly not implemented in storyboard") }

        return viewController
    }
    func updateUIViewController(_ uiViewController: ReportTableViewController, context: Context) { } // Update code
}
