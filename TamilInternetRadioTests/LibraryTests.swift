//
//  TamilInternetRadioTests.swift
//  TamilInternetRadioTests
//
//  Created by Sai Balaji on 08/08/26.
//

import XCTest
import CoreData
@testable import TamilInternetRadio

final class LibraryTests: XCTestCase{
    var mockPersistenceController: MockLibraryPeristenceController?
    var memoryController: PersistenceController?
    var sut: LibraryViewModel?
    
    override func setUp()   {
        super.setUp()
        memoryController = PersistenceController(inMemory: true)
        mockPersistenceController = MockLibraryPeristenceController(controller: memoryController!)
        sut = LibraryViewModel(persistenceController: mockPersistenceController!)
    }
    override func tearDown() {
        mockPersistenceController = nil
        super.tearDown()
    }
    
    func testFetchSuccess()throws {
        let station = SavedRadioStation(context: memoryController!.context)
        station.title = "Suryan FM Chennai"
        station.stationId = "9617a958-0601-11e8-ae97-52543be04c81"
        station.imageUrl = URL(string: "https://www.suryanfm.in/wp-content/uploads/2018/10/Header-icon.jpg")
        try mockPersistenceController?.saveData()
        
        sut!.fetchAllSavedStations()
        XCTAssertFalse(sut!.showMessage)
        XCTAssertEqual(sut!.savedStations.count, 1)
        XCTAssertTrue(sut!.message.isEmpty)
    }
    
    func testFetchFailure(){
        mockPersistenceController!.errorToThrow = NSError(domain: "Unable to fetch", code: -1)
        sut!.fetchAllSavedStations()
        XCTAssertFalse(sut!.message.isEmpty)
        XCTAssertEqual(sut!.savedStations.count, 0)
        XCTAssertTrue(sut!.showMessage)
    }
    
    
    
    
}
