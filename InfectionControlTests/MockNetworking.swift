//
//  MockNetworking.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import Foundation

/* Works in the following order:
 First create the mockNetworkManager and pass in a mockSession
 The mockSession has mutable data and err vars as well as an overriden dataTask() that returns our mockDataTask
 The mockDataTask can be used individually (with its simple init)or from inside the mockSession.
 Inside the mockSession, mockDataTask receives a closure that just calls our completionHandler when mockDataTask resume() is called
 Finally mockNetworkManager works mostly normally. When calling createFetchTask, the func we pass in is called by mockDataTask
 Basically mockDataTask resume() calls mockSession's completionHandler which calls our updateClosure
 */
typealias AnyClosure = () -> Void
class MockURLSessionDataTask: URLSessionDataTask {
    var closure: AnyClosure

    init(closure: @escaping AnyClosure) { // Technically deprecated but it's a mock so use it cause we need it
        self.closure = closure
    }

    override func resume() { // We override the 'resume' method to simply call closure()
        print("Running resume from mock")
        closure()
    }
}

class MockURLSession: URLSession {
    // Simplify param naming with this typealias
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var data: Data? // Easily swap out data or error for any URLSession instance if we need
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data; let err = self.error
        print("Running overriden dataTask")
        return MockURLSessionDataTask { completionHandler(data, nil, err) }
    }
}

class MockNetworkManager: CompleteNetworkManager {
    var baseURL: URL { return URL(string: "https://www.foobar.com")! }
    var urlSession: URLSession
    // Called in dataTask's completionHandler in place of closure passed into createFetchTask()
    var replacementClosure: AnyClosure?
    var replacementData: Data?
    
    init(session: URLSession, replacementClosure: AnyClosure? = nil, replacementData: Data? = nil) {
        self.urlSession = session
        self.replacementClosure = replacementClosure
        self.replacementData = replacementData
    }
    func setClosure(_ replacementClosure: AnyClosure?) {
        self.replacementClosure = replacementClosure
    }
    
    func fetchTask(endpointPath: String) async -> Data? {
        return self.replacementData
    }
    
    func createFetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask {
        return self.urlSession.dataTask(with: self.baseURL) { data, _, err in
            print("Running createFetchTask dataTask handler")
            self.replacementClosure != nil ? self.replacementClosure!() : updateClosure(data, err)
        }
    }
    
    func onFetchComplete(data: Data?, response: URLResponse?, error: Error?, dataHandler: (Data?, Error?) -> Void) {
        print("On Fetch Completed!")
    }
    
    func postRequest(endpointPath: String) -> URLRequest {
        return URLRequest(url: self.baseURL)
    }
}
