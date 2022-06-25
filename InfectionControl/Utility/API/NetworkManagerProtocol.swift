//
//  NetworkManagerProtocol.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

typealias DataUpdater = (Data?, Error?) -> Void // Technically = (Data) -> () since Void is actually an empty Tuple under the hood

protocol FetchingNetworkManager {
    var baseURL: URL { get }
    func fetchTask(endpointPath: String) async -> Data?
    func createFetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask
    func onFetchComplete(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater)
}
protocol PostingNetworkManager {
    var baseURL: URL { get }
    func postRequest(endpointPath: String) -> URLRequest
}

protocol CompleteNetworkManager: FetchingNetworkManager, PostingNetworkManager {
    var baseURL: URL { get }
    
    func fetchTask(endpointPath: String) async -> Data?
    func createFetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask
    func onFetchComplete(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater)
    
    func postRequest(endpointPath: String) -> URLRequest
}
