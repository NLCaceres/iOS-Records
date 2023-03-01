//  NetworkManager.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import RxSwift

/* Goal: Simplify the most common and generic logic involved across all calls to the remote API */
struct NetworkManager: CompleteNetworkManager {
    enum NetworkError: Error {
        case unexpectedResponse
        case clientErrCode
        case serverErrCode
        case unexpectedStatusCode
        case unexpectedMimeType
    }
    
    private let session: URLSession
    
    private let baseURL: URL // The prefix of the url so typically - "https://example.com/api"
    // This getter lets API networking funcs access the baseURL prop to ping the API
    // BUT ALSO by returning "localhost" during debug/development, I can avoid pinging the real server when not in production
    var apiURL: URL {
        #if DEBUG // Forces compilation to skip when production build happens
        if CommandLine.arguments.contains("-devServer") {
            return URL(string:"http://localhost:3000/api")!
        }
        #endif
        return self.apiURL
    }
    
    init(baseURL: URL = URL(string: "https://infection-prevention-express.herokuapp.com/api")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: GET HTTP Methods + Async version 1st
    func fetchTask(endpointPath: String) async -> Result<Data?, Error> {
        let endpointURL = self.baseURL.appendingPathComponent(endpointPath)
        do {
            let (data, response) = try await session.data(from: endpointURL)
            return onHttpResponse(data: data, response: response, error: nil, dataHandler: nil)
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    /// While the above fetchTask can be easily used with the new "async/await" syntax, the following version expects to be used the "old-fashioned way" via callbacks, accepting a trailing closure
    // Marked @escaping since dataTask calls its closure after the request/func completes meaning our update called inside it does too!
    func fetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask {
        let endpointURL = self.baseURL.appendingPathComponent(endpointPath)
        return session.dataTask(with: endpointURL) { data, response, error in
            onHttpResponse(data: data, response: response, error: error, dataHandler: updateClosure)
        } // Returning dataTask allows controllers to store & cancel it if needed (like in viewWillDisappear)
    }
    
    /// Use the following to parse through the HTTP Response, catching errors before letting the client receive and handle the data fetched
    @discardableResult
    func onHttpResponse(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater?) -> Result<Data?, Error> {
        if let error = error { // Protect against all errors
            print("Found an error: \(error.localizedDescription)")
            if let dataHandler = dataHandler { dataHandler(nil, error) }
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            if let dataHandler = dataHandler { dataHandler(nil, NetworkError.unexpectedResponse) }
            return .failure(NetworkError.unexpectedResponse)
        }
        // Only want 200 Status Codes else throw a 400 Client Err or 500 Internal Err
        guard (200...299).contains(httpResponse.statusCode) else {
            let networkErr: NetworkError
            if (400...499).contains(httpResponse.statusCode) {
                print("Found an error related to 400s Client Err")
                networkErr = .clientErrCode
            } else if  (500...599).contains(httpResponse.statusCode) {
                print("Found an error related to 500s Internal Server Err")
                networkErr = .serverErrCode
            } else {
                print("Unexpected status code")
                networkErr = .unexpectedStatusCode
            }
            if let dataHandler = dataHandler { dataHandler(nil, networkErr) }
            return .failure(networkErr)
        }
        
        guard let mime = httpResponse.mimeType, mime == "application/json" else {
            if let mime = httpResponse.mimeType { print("Mime type not matching expected: JSON - \(mime)") }
            else { print("No mime type found") }
            
            if let dataHandler = dataHandler { dataHandler(nil, NetworkError.unexpectedMimeType) }
            return .failure(NetworkError.unexpectedMimeType)
        }
        
        if let data = data {
            if let dataHandler = dataHandler { dataHandler(data, nil) }
            else { return .success(data) }
        }
        return .success(nil)
    }
    
    
    // MARK: POST HTTP Methods with Async stub
    // Should be anticipating a good status code from postRequests aka 201, 202, 204
    func postRequest(endpointPath: String) -> URLRequest {
        var newPostRequest = URLRequest(url: self.baseURL.appendingPathComponent(endpointPath))
        newPostRequest.httpMethod = "POST" // Have to configure POST request outside of init
        newPostRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        newPostRequest.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        return newPostRequest
    }
    func postRequest(endpointPath: String) async {
        
    }
}
