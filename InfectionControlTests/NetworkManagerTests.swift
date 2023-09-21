//
//  NetworkManagerTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    override func setUp() {
        if !CommandLine.arguments.contains("-devServer") {
            CommandLine.arguments.append("-devServer")
        }
        networkManager = NetworkManager()
    }
    override func tearDown() {
        if let devServerIndex = CommandLine.arguments.firstIndex(of: "-devServer") {
            CommandLine.arguments.remove(at: devServerIndex)
        }
        networkManager = nil
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.error = nil
    }
    
    func testApiUrl() {
        let devUrlString = "http://localhost:8080/api"
        let productionUrlString = "http://example.com/foo"
        let exampleNetworkManager = NetworkManager(baseURL: URL(string: productionUrlString)!)
        // Test runner uses dev args by default so "-devServer" launch arg is added in, and the "localhost" URL is used instead of baseURL
        XCTAssertEqual(exampleNetworkManager.apiURL.absoluteString, devUrlString)
        
        CommandLine.arguments.remove(at: CommandLine.arguments.firstIndex(of: "-devServer")!)
        // WHEN "-devServer" launch arg is removed, THEN the baseURL is used instead of "localhost"
        XCTAssertEqual(exampleNetworkManager.apiURL.absoluteString, productionUrlString)
    }
    
    // MARK: Fetching
    func testFetchTaskURL() { // Simulate fetchTask appending paths
        let dataTask = networkManager.fetchTask(endpointPath: "barfoo") { _, _ in () }
        let thisRequestURL = dataTask.originalRequest!.url!
        XCTAssertEqual(thisRequestURL.absoluteString, "http://localhost:8080/api/barfoo")
        let thisRequestBaseURL = thisRequestURL.deletingLastPathComponent() // Should == private URL used by NetworkManager
        XCTAssertEqual(thisRequestBaseURL.absoluteString, "http://localhost:8080/api/")
        
        let otherDataTask = networkManager.fetchTask(endpointPath: "/foobam") { _, _ in () }
        let otherRequestURL = otherDataTask.originalRequest!.url!
        XCTAssertEqual(otherRequestURL.absoluteString, "http://localhost:8080/api/foobam")
    }
    func testFetchTask() {
        // Closure passed in doesn't matter since not calling resume
        let dataTask = networkManager.fetchTask(endpointPath: "foobar") { _, _ in () }
        let endpointPathComponent = dataTask.originalRequest!.url!.pathComponents[2] // pathComponents() -> ["/", "api", "foobar"]
        XCTAssertEqual(endpointPathComponent, "foobar")
        // DataTask is not yet running since no resume call (therefore suspended)
        XCTAssertEqual(dataTask.state, .suspended)
    }
    func testAsyncFetchTask() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200,
                                           httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            return (response, EmployeeDTO(firstName: "Brian", surname: "Ishida").toData()!)
        }
        let newNetworkManager = NetworkManager(session: MockURLSession.stubURLSession())
        let typedResult = await getBase(for: EmployeeDTO.self) {
            await newNetworkManager.fetchTask(endpointPath: "some-endpoint")
        }
        let employee = try! typedResult.get()!
        XCTAssertEqual(employee.firstName, "Brian") // Get the MockURLProtocol returned employee
        XCTAssertEqual(employee.surname, "Ishida")
        
        // WHEN onHttpResponse handler finds something unexpected in the response, like a 404 status code
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404,
                                           httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            return (response, EmployeeDTO(firstName: "Brian", surname: "Ishida").toData()!)
        }
        // THEN the result is a failure()
        let notFoundResult = await getBase(for: EmployeeDTO.self) {
            await newNetworkManager.fetchTask(endpointPath: "some-endpoint")
        }
        let notFoundEmployee = try? notFoundResult.get()
        XCTAssertNil(notFoundEmployee) // AND employee is nil
        
        // WHEN the request itself fails
        MockURLProtocol.error = MockError.description("Bad request! It failed!")
        let errorResult = await getBase(for: EmployeeDTO.self) {
            await newNetworkManager.fetchTask(endpointPath: "some-endpoint")
        }
        // THEN error is caught and .failure() returned
        let errorEmployee = try? errorResult.get()
        XCTAssertNil(errorEmployee) // AND employee here is also nil
    }
    
    // MARK: Generic HTTP Response Handler
    func testOnUnexpectedHttpResponse() {
        // Check each error throws as expected, starting with an invalid or missing response
        // WHEN all params are nil
        networkManager.onHttpResponse(data: nil, response: nil, error: nil) { data, err in
            guard let err = err as? NetworkManager.NetworkError else {
                XCTFail("Err wasn't passed in"); return;
            }
            XCTAssertTrue(err == .unexpectedResponse) // THEN expect err is unexpectedResponse
        }
    }
    func testOnHttpResponseStatusCodeErrors() {
        let fooURL = URL(string: "https://www.foobar.com")!
        // WHEN status == 100
        let unexpectedStatusResponse = HTTPURLResponse(url: fooURL, statusCode: 100, httpVersion: nil, headerFields: nil)
        networkManager.onHttpResponse(data: nil, response: unexpectedStatusResponse, error: nil) { data, err in
            // THEN expect err is unexpectedStatusCode
            if let err = err as? NetworkManager.NetworkError {
                XCTAssertTrue(err == .unexpectedStatusCode)
            } else {
                XCTFail("Error wasn't passed in and is nil")
            }
        }
            
        // WHEN status == 400
        let clientErrResponse = HTTPURLResponse(url: fooURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        networkManager.onHttpResponse(data: nil, response: clientErrResponse, error: nil) { data, err in
            // THEN expect err is clientErrCode
            if let err = err as? NetworkManager.NetworkError {
                XCTAssertTrue(err == .clientErrCode)
            } else {
                XCTFail("Error wasn't passed in and is nil")
            }
        }

        // WHEN status == 500
        let serverErrResponse = HTTPURLResponse(url: fooURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        networkManager.onHttpResponse(data: nil, response: serverErrResponse, error: nil) { data, err in
            // THEN expect err is serverErrCode
            if let err = err as? NetworkManager.NetworkError {
                XCTAssertTrue(err == .serverErrCode)
            } else {
                XCTFail("Error wasn't passed in and is nil")
            }
        }
    }
    func testOnHttpResponseErr() {
        let fooURL = URL(string: "https://www.foobar.com")!
        // WHEN 200 status code BUT invalid content-type
        let badMimeTypeResponse = HTTPURLResponse(url: fooURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        networkManager.onHttpResponse(data: nil, response: badMimeTypeResponse, error: nil) { data, err in
            // THEN expect err is unexpectedMimeType
            if let err = err as? NetworkManager.NetworkError {
                XCTAssertTrue(err == .unexpectedMimeType)
            } else {
                XCTFail("Error wasn't passed in and is nil")
            }
        }
        
        // WHEN 200 status code in a normal HTTPResponse
        let validHttpResponse = HTTPURLResponse(url: fooURL, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])
        networkManager.onHttpResponse(data: nil, response: validHttpResponse, error: nil) { data, err in
            XCTAssertTrue(err == nil) // THEN no err passed in!
        }
        
        let fooData = try! JSONEncoder().encode(AssertableData(didChange: true))
        var foobar = AssertableData()
        // WHEN 200 status in a normal HTTPResponse with a completion Handler
        networkManager.onHttpResponse(data: fooData, response: validHttpResponse, error: nil) { data, err in
            XCTAssertTrue(err == nil)
            guard let data = data else { return }
            
            XCTAssertEqual(false, foobar.didChange) // Started as false, should be updated to true
            let foobarDTO = AssertableData(try! JSONDecoder().decode(AssertableData.self, from: data)) // Pass in data
            XCTAssertTrue(foobar !== foobarDTO) // Two different AssertableData instances
            foobar = foobarDTO
            XCTAssertTrue(foobar === foobarDTO) // Now same instance
            XCTAssertEqual(true, foobar.didChange) // Started as false, now set to true based on httpResponse encoded data
        }
    }
}
