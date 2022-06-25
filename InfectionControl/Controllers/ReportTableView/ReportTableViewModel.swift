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
    let networkManager: FetchingNetworkManager
    private let isLoading = BehaviorRelay(value: false)
    var isLoadingDisplay: Observable<Bool> {
        return isLoading.asObservable().distinctUntilChanged()
    }
    // Making relay private ensures only viewModel can modify it. Observers/Subscribers just observe from observable props
    private let reportCells = BehaviorRelay<[ReportTableCellViewModel]>(value: [])
    var reportCellViewModels: Observable<[ReportTableCellViewModel]> {
        return reportCells.asObservable()
    }
    
    init(networkManager: FetchingNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: DataFetching
    func getReports() {
        self.isLoading.accept(true)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let myVM = self else { return }
            myVM.networkManager.createFetchTask(endpointPath: "reports", updateClosure: myVM.setupReportViewCell).resume()
        }
    }
    
    private func setupReportViewCell(data: Data?, err: Error?) {
        self.isLoading.accept(false)
        guard let reportData = data else { return }
        
        if let decodedReports = reportData.toArray(containing: ReportDTO.self) {
            var newReports = [ReportTableCellViewModel]()
            for decodedReport in decodedReports {
                if let thisReport = decodedReport.toBase() {
                    newReports.append(ReportTableCellViewModel(report: thisReport))
                }
                else { // Prefer if let over guard let so that func won't return + isLoading becomes false
                    print("Initialization failed, missing important details")
                }
            }
            self.reportCells.accept(newReports) // Once we're sure of our decodedVals, push in our new array as a new observableEvent
        }
    }
}
