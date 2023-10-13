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
 Finally mockNetworkManager works mostly normally. When calling fetchTask, the func we pass in is called by mockDataTask
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

class MockURLProtocol: URLProtocol {
    //? These vars need to be static to be modifiable since MockURLProtocol is never actually instantiated,
    //? the Protocol Type is just injected into the config of my NetworkManager's URLSession
    static var error: Error?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true // Ensure our fake request runs
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request // Send back our fake request without modifying it
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("No handler has been set yet")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Called if a cancel signal is sent, so likely not going to be an issue during Stub/Mocking
    }
}

class MockURLSession: URLSession {
    // Simplify param naming with this typealias
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var data: Data? = nil // Easily swap out data or error for any URLSession instance if we need
    var error: Error? = nil
    
    static func stubURLSession() -> URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self] // Override protocol classes to ensure requests are handled how I want
        return URLSession(configuration: configuration)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data; let err = self.error
        print("Running overriden dataTask")
        return MockURLSessionDataTask { completionHandler(data, nil, err) }
    }
}

class MockNetworkManager: CompleteNetworkManager {
    var apiURL: URL { return URL(string: "https://www.foobar.com")! }
    var urlSession: URLSession
    // Called in dataTask's completionHandler in place of closure passed into fetchTask()
    var replacementClosure: AnyClosure?
    var replacementData: Data?
    var error: Error?
    
    init(session: URLSession = MockURLSession(), replacementClosure: AnyClosure? = nil, replacementData: Data? = nil, error: Error? = nil) {
        self.urlSession = session
        self.replacementClosure = replacementClosure
        self.replacementData = replacementData
        self.error = error
    }
    func setClosure(_ replacementClosure: AnyClosure?) {
        self.replacementClosure = replacementClosure
    }
    
    func fetchData(endpointPath: String) async -> Result<Data?, Error> {
        if let error = error { return .failure(error) }
        return .success(self.replacementData)
    }
    
    func fetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask {
        return self.urlSession.dataTask(with: self.apiURL) { data, _, err in
            print("Running fetchTask with a dataTask handler")
            self.replacementClosure != nil ? self.replacementClosure!() : updateClosure(data, err)
        }
    }
    
    func onHttpResponse(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater?) -> Result<Data?, Error> {
        print("On Fetch Completed!")
        return .success(nil)
    }
    
    func postRequest(endpointPath: String) -> URLRequest {
        return URLRequest(url: self.apiURL)
    }
    func sendPostRequest(with encodableData: Encodable, endpointPath: String) async -> Result<Data?, Error> {
        if let error = error { return .failure(error) }
        return .success(self.replacementData ?? encodableData.toData())
    }
}
