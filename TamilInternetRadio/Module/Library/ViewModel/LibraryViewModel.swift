//
//  LibraryViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine
import CoreData


class LibraryViewModel: ObservableObject{
    @Published var savedStations = [SavedRadioStation]()
    @Published var showMessage: Bool = false
    @Published var message = ""
    @Published var stationData: RadioStation?
    @Published var isLoading: Bool = false
    private let persistenceController: PersistenceProtocol
    private let networkService: NetworkServiceProtocol
    init(persistenceController: PersistenceProtocol, networkService: NetworkServiceProtocol){
        self.persistenceController = persistenceController
        self.networkService = networkService
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(handleLibraryDidChange),
                   name: NSNotification.Name("STATIONSAVED"),
                   object: nil
               )
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    func fetchAllSavedStations(){
        do{
            let result: [SavedRadioStation] = try self.persistenceController.fetchAllData(from: "SavedRadioStation")
            self.savedStations = result
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
        }
    }
    
    @objc func handleLibraryDidChange(){
        self.fetchAllSavedStations()
    }
    
    func getStationInfo(id: String)async {
        defer{
            self.isLoading = false
        }
        do{
            self.isLoading = true
            let result: [RadioStation] = try await self.networkService.performRequest(endPoint: .stationInfo(stationId: id), body: nil as String?)
            if let stationData = result.first{
                self.stationData = stationData
            }
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
        }
    }
}
