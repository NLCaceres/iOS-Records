//
//  CreateReportViewModel.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import Combine

class CreateReportViewModel: ObservableObject {
    
    // MARK: Properties
    let networkManager: CompleteNetworkManager
    
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
    
    var saveButtonEnabled: AnyPublisher<Bool, Never> {
        self.$reportEmployee.combineLatest(self.$reportHealthPractice, self.$reportLocation, self.$reportDate) {
            return $0 != nil && $1 != nil && $2 != nil && $3 != nil
        }.eraseToAnyPublisher() // If all report values set, then time to send
    }
    
    init(networkManager: CompleteNetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Async Func
    func beginFetching() async {
        self.isLoading = true
        // Following await should run both funcs in parallel
        (healthPracticePickerOptions, locationPickerOptions) = await (
            fetchDTOArr(endpointPath: "healthpractices", containing: HealthPracticeDTO.self, networkManager: self.networkManager),
            fetchDTOArr(endpointPath: "locations", containing: LocationDTO.self, networkManager: self.networkManager)
        )
        self.isLoading = false
    }
    func postNewReport() async {
        defer { self.isLoading = false }
        self.isLoading = true
        
        guard let employee = self.reportEmployee, let healthPractice = self.reportHealthPractice,
              let location = self.reportLocation, let date = self.reportDate else { return }
        
        let fullReport = Report(employee: employee, healthPractice: healthPractice, location: location, date: date)

        let jsonReport = ReportDTO(from: fullReport).toData() // Use ! since JUST set fullReport above
        let postRequest = self.networkManager.postRequest(endpointPath: "reports/create")
        let putTask = URLSession.shared.uploadTask(with: postRequest, from: jsonReport) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Data was returned: \(dataString)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Received a response: \(httpResponse.statusCode)")
            }
        }
        putTask.resume()
        self.isLoading = false
    }
}
