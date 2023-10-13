//
//  NetworkManagerProtocol.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

typealias DataUpdater = (Data?, Error?) -> Void // Technically = "(Data, Error) -> ()" since Void is actually an empty Tuple under the hood

protocol FetchingNetworkManager {
    var apiURL: URL { get }
    func fetchData(endpointPath: String) async -> Result<Data?, Error>
    func fetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask
    func onHttpResponse(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater?) -> Result<Data?, Error>
}
protocol PostingNetworkManager {
    var apiURL: URL { get }
    func postRequest(endpointPath: String) -> URLRequest //TODO: Keep the POST request maker in the protocol? or let the Manager decide it privately?
    func sendPostRequest(with encodableData: Encodable, endpointPath: String) async -> Result<Data?, Error>
}

protocol CompleteNetworkManager: FetchingNetworkManager, PostingNetworkManager {
    var apiURL: URL { get }
    
    func fetchData(endpointPath: String) async -> Result<Data?, Error>
    func fetchTask(endpointPath: String, updateClosure: @escaping DataUpdater) -> URLSessionDataTask
    func onHttpResponse(data: Data?, response: URLResponse?, error: Error?, dataHandler: DataUpdater?) -> Result<Data?, Error>
    
    func postRequest(endpointPath: String) -> URLRequest
    func sendPostRequest(with encodableData: Encodable, endpointPath: String) async -> Result<Data?, Error>
}
