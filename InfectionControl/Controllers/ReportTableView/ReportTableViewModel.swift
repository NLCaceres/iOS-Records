//
//  ReportTableViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import RxSwift
import RxRelay

// View Models can be plain or smart - Smart is what we're after
// Plain would be just something that holds data and serves it to the controller/view
// Smart handles more concerns! Requests data, formats it, notifies VC, etc.
// Dealing with those concerns here rather than in the VC can simplify testing + keeps code decoupled/reusable
class ReportTableViewModel {
    // MARK: Properties
    private let reportRepository: ReportRepository
    private let isLoading = BehaviorRelay(value: false)
    var isLoadingDisplay: Observable<Bool> {
        return isLoading.asObservable().distinctUntilChanged()
    }
    // Making this BehaviorRelay private ensures only viewModel can modify it. Observers/Subscribers just observe from observable props
    private let reportCells = BehaviorRelay<[ReportTableCellViewModel]>(value: [])
    var reportCellViewModels: Observable<[ReportTableCellViewModel]> {
        return reportCells.asObservable()
    }
    
    init(reportRepository: ReportRepository = AppReportRepository()) {
        self.reportRepository = reportRepository
    }
    
    // MARK: DataFetching
    func getReportList() async {
        isLoading.accept(true)
        do {
            let reportsList = try await reportRepository.getReportList()
            let reportCellVmList = reportsList.map { ReportTableCellViewModel(report: $0) }
            reportCells.accept(reportCellVmList) // Emits an observable event to update the tableView
        }
        catch {
            print("Got the following error while fetching reports: \(error.localizedDescription)")
        }
        isLoading.accept(false)
    }
}
