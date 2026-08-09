//
//  SearchTests.swift
//  TamilInternetRadioTests
//
//  Created by Sai Balaji on 09/08/26.
//

import Foundation
import XCTest
@testable import TamilInternetRadio

class MockNetworkService: NetworkServiceProtocol{
    var errorToThrow: NetworkServiceError?
    var cancellationError: URLError?
    var mockResponse: Any?
    func performRequest<T, U>(endPoint: EndPoint, body: U?) async throws -> T where T : Decodable, U : Encodable {
        if let cancellationError{
            throw cancellationError
        }
        guard let mockResponse = mockResponse as? T else{
            
            throw errorToThrow!
            
        }
        return mockResponse
    }
}

@MainActor
class SearchTests: XCTestCase{
    private var sut: SearchViewModel!
    private var mockNetworkService: MockNetworkService!
    
    override func setUp(){
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = SearchViewModel(service: mockNetworkService)
    }
    override func tearDown(){
        mockNetworkService = nil
        sut = nil
        super.tearDown()
    }
    func testSearchSuccess()async {
        mockNetworkService.errorToThrow = nil
        mockNetworkService.cancellationError = nil
        mockNetworkService.mockResponse = RadioStation.mockArray
        sut.searchText = "Big"
        await sut.searchRadioStation()
        XCTAssertFalse(sut.searchResult.isEmpty)
        XCTAssertFalse(sut.showMessage)
        XCTAssertFalse(sut.showNoResultView)
    }
    func testSearchWithEmptyText()async{
        mockNetworkService.errorToThrow = nil
        mockNetworkService.cancellationError = nil
        mockNetworkService.cancellationError = nil
        mockNetworkService.mockResponse = RadioStation.mockArray
        sut.searchText = ""
        await sut.searchRadioStation()
        //The array will be empty because API call will not happen for empty string
        XCTAssertTrue(sut.searchResult.isEmpty)
        XCTAssertFalse(sut.showMessage)
        XCTAssertFalse(sut.showNoResultView)
    }
    func testSearchWithNoMatchingResult()async{
        mockNetworkService.errorToThrow = nil
        mockNetworkService.mockResponse = [RadioStation]() //no matching result so empty array
        sut.searchText = "BigTest"
        await sut.searchRadioStation()
        XCTAssertTrue(sut.searchResult.isEmpty)
        XCTAssertTrue(sut.showNoResultView)
        XCTAssertFalse(sut.showMessage)
    }
    
    func testSearchResultAPIFailure()async{
        mockNetworkService.errorToThrow = .invalidStatus(code: 400)
        mockNetworkService.cancellationError = nil
        mockNetworkService.mockResponse = nil //no response will come from api if api fails
        sut.searchText = "BigTest"
        await sut.searchRadioStation()
        XCTAssertTrue(sut.searchResult.isEmpty)
        XCTAssertTrue(sut.showMessage)
        XCTAssertFalse(sut.showNoResultView)
    }
    func testCancellationErrorFlowInDebounce()async{
        mockNetworkService.errorToThrow = nil
        mockNetworkService.cancellationError = URLError(.cancelled)
        mockNetworkService.mockResponse = nil
        sut.searchText = "Test"
        await sut.searchRadioStation()
        XCTAssertTrue(sut.searchResult.isEmpty)
        XCTAssertFalse(sut.showMessage)
        XCTAssertFalse(sut.showNoResultView)
        
    }
    
}
