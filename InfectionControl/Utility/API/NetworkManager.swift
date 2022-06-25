//  NetworkManager.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import RxSwift

struct NetworkManager: CompleteNetworkManager {
    enum NetworkError: Error {
        case unexpectedResponse
        case clientErrCode
        case serverErrCode
        case unexpectedStatusCode
        case unexpectedMimeType
    }
    
    private let urlSession: URLSession
    
    private let urlPrefix: URL
    var baseURL: URL {
        #if DEBUG // Forces compilation to skip when production build happens
        if CommandLine.arguments.contains("-devServer") {
            print("Return url to dev server")
        }
        #endif
        return self.urlPrefix
    }
    
    init(baseURL: URL = URL(string: "https://infection-prevention-express.herokuapp.com/api")!, session: URLSession = .shared) {
        self.urlPrefix = baseURL
        self.urlSession = session
    }
    
    // MARK: GET HTTP Methods + Async version 1st
    func fetchTask(endpointPath: String) async -> Data? {
        let endpointURL = self.baseURL.appendingPathComponent(endpointPath)
        do {
            let (data, response) = try await urlSession.data(from: endpointURL)
            // TODO: Could refactor/merge with createFetchTask by using optional closures
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                if (400...499).contains(httpResponse.statusCode) {
                    print("Found an error related to 400s Client Err")
                } else if  (500...599).contains(httpResponse.statusCode) {
                    print("Found an error related to 500s Internal Server Err")
                } else {
                    print("Unexpected status code")
                }
                return nil
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                if let mime = response.mimeType { print("Mime type not matching expected: JSON - \(mime)") }
                else { print("No mime type found") }
                return nil
            }
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // Marked @escaping since dataTask calls its closure after the request/func completes meaning our update called inside it does too!
    func createFetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask {
        let endpointURL = self.baseURL.appendingPathComponent(endpointPath)
        return urlSession.dataTask(with: endpointURL) { data, response, error in
            onFetchComplete(data: data, response: response, error: error, dataHandler: updateClosure)
        } // Returning dataTask allows controllers to store & cancel it later
    }
    // Generalized/Common error handling before sending data back to View
    func onFetchComplete(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater) {
        if let error = error { // Protect against all errors
            print("Found an error: \(error.localizedDescription)")
//            if let errHandler = dataHandler {
//                dataHandler(nil, error)
//                return
//            }
//            else { return nil }
            dataHandler(nil, error)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            dataHandler(nil, NetworkError.unexpectedResponse)
            return
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
                networkErr = .unexpectedStatusCode
            }
            dataHandler(nil, networkErr)
            return
        }
        guard let mime = response?.mimeType, mime == "application/json" else {
            dataHandler(nil, NetworkError.unexpectedMimeType)
            return
        }
        if let data = data {
            dataHandler(data, nil)
        }
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
