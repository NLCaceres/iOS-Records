//
//  CreateReportViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import Combine

class CreateReportViewModel: ObservableObject {
    
    // MARK: Properties
    private let healthPracticeRepository: HealthPracticeRepository
    private let locationRepository: LocationRepository
    private let reportRepository: ReportRepository
    
    // CURRENTLY @Published is syntactic sugar for CurrentValueSubject<Type, Never>
    // PROS: In an ObservableObject, ANY changes to @Published props causes
    // subscribers of the props parent ObservableObject to be notified
    // CONS: No chance of error, NEED to be in a class, can't subscribe to others
    // (without using $propName version aka its projected value, a Publisher associated type)
    @Published private(set) var isLoading = false
    
    // Following ONLY can get input vals into the stream from this file. ViewController has no say.
    @Published private(set) var healthPracticePickerOptions: [HealthPractice] = []
    @Published private(set) var locationPickerOptions: [Location] = []
    
    @Published var reportEmployee: Employee?
    @Published var reportHealthPractice: HealthPractice?
    @Published var reportLocation: Location?
    @Published var reportDate: Date? = Date()
    
    @Published private(set) var errorMessage: String = "" // If empty string, then view should determine no error has occurred
    
    var saveButtonEnabled: AnyPublisher<Bool, Never> {
        self.$reportEmployee.combineLatest(self.$reportHealthPractice, self.$reportLocation, self.$reportDate) {
            return $0 != nil && $1 != nil && $2 != nil && $3 != nil
        }.eraseToAnyPublisher() // If all report values set, then time to send
    }
    
    init(healthPracticeRepository: HealthPracticeRepository = AppHealthPracticeRepository(),
         locationRepository: LocationRepository = AppLocationRepository(),
         reportRepository: ReportRepository = AppReportRepository()) {
        self.healthPracticeRepository = healthPracticeRepository
        self.locationRepository = locationRepository
        self.reportRepository = reportRepository
    }
    
    // MARK: Async Func
    func beginFetching() async {
        self.isLoading = true
        // Using "async let" as follows OR "await withTaskGroup()" is pretty much the only guaranteed way to do parallel execution
        async let healthPractices = healthPracticeRepository.getHealthPracticeList()
        async let locations = locationRepository.getLocationList()
        do { /// To learn how to visualize concurrency via "Points of Interest" instruments + TimeProfile, then check out "https://developer.apple.com/videos/play/wwdc2022/110350/"
            (healthPracticePickerOptions, locationPickerOptions) = try await (healthPractices, locations)
        }
        catch {
            print("Got the following error while fetching the healthPractices and locations - \(error.localizedDescription)")
        }
        self.isLoading = false //? Should still run after catch block handles any errors. No defer needed!
    }
    func postNewReport() async {
        defer { self.isLoading = false } // Helps with the guard clause
        self.isLoading = true
        
        guard let employee = self.reportEmployee, let healthPractice = self.reportHealthPractice,
              let location = self.reportLocation, let date = self.reportDate else { return }
        
        let fullReport = Report(employee: employee, healthPractice: healthPractice, location: location, date: date)
        
        do {
            let successfullyCreatedReport = try await self.reportRepository.createNewReport(fullReport)
            self.clearReport()
        }
        catch {
            print("Got the following error while attempting to create a new Report - \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    private func clearReport() {
        self.reportEmployee = nil
        self.reportHealthPractice = nil
        self.reportLocation = nil
        self.reportDate = nil
    }
}
