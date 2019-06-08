//
//  DataHandler.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/31/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa

class DataHandler {
    
    static func decodeHelper<T: Decodable>(_ endpointURL: URL, decodeType: T.Type, completionHandler: @escaping (Decodable) -> ()) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: endpointURL) { data, response, error in
            if let error = error {
                print("Found an error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Found an error related to status code")
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Not receiving a JSON!")
                return
            }
            if let data = data {
                do {
                    let decodedModel = try JSONDecoder().decode(decodeType, from: data)
                    completionHandler(decodedModel)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
    }
    static func fetchJSON<T: Decodable>(_ endpointURL: URL, updateClosure: @escaping ([T]) -> () ) {
        DispatchQueue.global(qos: .userInteractive).async {
            let task = decodeHelper(endpointURL, decodeType: [T].self) { decodedModel in
                DispatchQueue.main.async {
                    let decodedObjArr = decodedModel as! [T]
                    updateClosure(decodedObjArr)
                }
            }
            task.resume()
        }
    }
    
    typealias DataUpdater = (Data) -> ()
    static func fetchJSONData(_ endpointURL: URL, _ updateClosure: @escaping DataUpdater) {
        DispatchQueue.global(qos: .userInteractive).async {
            let fetchJSONTask = fetchTaskCreater(endpointURL, updateClosure)
            fetchJSONTask.resume()
        }
    }
    static func fetchTaskCreater(_ endpointURL: URL, _ updateClosure: @escaping DataUpdater) -> URLSessionDataTask {
        print("Calling from Data Handler class")
        return URLSession.shared.dataTask(with: endpointURL, completionHandler: { data, response, error in
            // Could use a defer on a var getTask if we wanted to reset getTasks often
            // Defer would fire on closure finish
            
            // Protect against these 3 in a http fetch
            if let error = error {
                // Must implement handler
                // self.handleClientError(error)
                print("Found an error: \(error.localizedDescription)" )
                return
            }
            
            // 200 to 299 is all checked against
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    // Implement this too!
                    // self.handleServerError(error)
                    // or throw and chain promise
                    print("Found an error related to status code")
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            if let data = data {
                // Had to mark the following as escaping
                // (Effectively the same since it is what we do to handle data returned anyway)
                updateClosure(data)
            }
        })
    }
    
    
    
//    static func fetchTaskMaker(_ endpointURL: URL) -> Observable<[Employee]> {
//        print("Calling from Data Handler Fetch Maker class")
//        return URLSession.shared.rx.json(url: endpointURL).retry(3).map { (json: Any) -> [Employee] in
//
//        }
//    }
    
    // Considering using T (template to handle generic decoding)
    // let decodedHealthPractices = try jsonDecoder.decode([HealthPractice].self, from: data)
    // becomes
    // let decodedObj = try jsonDecoder.decode([T].self, from: data)
//    static func decodeModel<T: Decodable>(data: Data) {
//        do {
//            let jsonDecoder = JSONDecoder()
//            let decodedModel = try jsonDecoder.decode([T].self, from: data)
//            for decodedObj in decodedModel {
//                print("This is the decoded obj \(decodedObj)")
//            }
//        }
//    }
//
//    func decodeEmployeeList(data: Data) {
//        do {
//            let jsonDecoder = JSONDecoder()
//            let decodedEmployees = try jsonDecoder.decode([Employee].self, from: data)
//
//            for decodedEmployee in decodedEmployees {
//                print("This is the decoded report \(decodedEmployee)")
//                if decodedEmployee.profession == nil {
//                    print("Missing profession for some reason")
//                    return
//                }
//                employees.append(decodedEmployee)
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.tableView.refreshControl?.endRefreshing()
//            }
//
//        } catch {
//            print("Error in updateReports: \(error)")
//        }
//    }
    
}
