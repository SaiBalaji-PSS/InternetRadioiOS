//
//  StationDetailViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine
import AVFoundation
import CoreData

@MainActor
class StationDetailViewModel: ObservableObject{
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    @Published var isPlaying: Bool = false
    @Published var saveSuccess: Bool = false
    @Published var liveLabelOpacity: Double = 0.0
    let playerService: PlayerService
    var timer: Timer?
    
    private let service: NetworkServiceProtocol
    private let persistenceController: PersistenceProtocol
    
    init(service: NetworkServiceProtocol,playerService: PlayerService,persistenceController: PersistenceProtocol){
        self.service = service
        self.playerService = playerService
        self.persistenceController = persistenceController
    }
  
    func getResolvedUrl(for stationId: String)async{
        do{
            let result: StationUrlModel = try await self.service.performRequest(endPoint: .streamingUrl(stationId: stationId), body: nil as String?)
            if result.ok{
                if let url = result.url, let streamingURL = URL(string: url){
                    self.play(url: streamingURL)
                    
                }
                else{
                    self.showMessage = true
                    self.message = "Invalid streaming url"
                  
                }
            }
            else{
                self.showMessage = true
                self.message = "An error occured while resolving the streaming url"
                
            }
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
            
        }
    }
    func play(url: URL){
        self.playerService.play(url: url)
        self.startLiveLabelBlinking()
        self.isPlaying = true
    }
    func pause(){
        self.playerService.pause()
       
        self.stopLiveLabelBlinking()
        self.isPlaying = false
    }
    //Stops the current play, refreshes streaming url
    func refresh(stationId: String)async {
        self.playerService.stop()
        await self.getResolvedUrl(for: stationId)
        
    }
    
    func saveRadioStationToLibrary(radioStation: RadioStation){
        let radioStationData = SavedRadioStation(context: self.persistenceController.getViewContext())
        radioStationData.stationId = radioStation.stationUuid
        radioStationData.title = radioStation.name
        if let imageURLString = radioStation.favicon, let imageURL = URL(string:imageURLString){
            radioStationData.imageUrl = imageURL
        }
        do{
            try self.persistenceController.saveData()
            self.saveSuccess = true
            self.showMessage = true
            self.message = "Station added to library."
            NotificationCenter.default.post(name: NSNotification.Name("STATIONSAVED"), object: nil)
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
            self.saveSuccess = false
        }
        
    }
    
    func removeFromFavorite(radioStation: RadioStation){
        guard let stationId = radioStation.stationUuid else {
           
            return
        }
        
        do {
            let predicate = NSPredicate(format: "stationId == %@", stationId)
            let matchingStations = try PersistenceController.shared.fetchAllDataWithPredicate(
                from: "SavedRadioStation",   // <-- your Core Data entity name
                predicate: predicate
            )
            if let matchingData = matchingStations.first{
                try PersistenceController.shared.deleteData(data: matchingData)
                self.saveSuccess = false
            }
        }
        catch {
            self.showMessage = true
            self.message = error.localizedDescription
            self.saveSuccess = false
        }
    }
    
    func checkIfStationIsAlreadySaved(radioStation: RadioStation) {
        guard let stationId = radioStation.stationUuid else {
           
            return
        }
        
        do {
            let predicate = NSPredicate(format: "stationId == %@", stationId)
            let matchingStations = try PersistenceController.shared.fetchAllDataWithPredicate(
                from: "SavedRadioStation",   // <-- your Core Data entity name
                predicate: predicate
            )
            self.saveSuccess = !matchingStations.isEmpty
        }
        catch {
            self.showMessage = true
            self.message = error.localizedDescription
            self.saveSuccess = false
        }
    }
    
    func startLiveLabelBlinking(){
        if self.timer?.isValid ?? false{
            return
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true , block: { [weak self] timer  in
            
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.liveLabelOpacity = self.liveLabelOpacity == 0.0 ? 1.0 : 0.0
            }
        })
    }
    
    
    func stopLiveLabelBlinking(){
        self.timer?.invalidate()
        self.timer = nil
        self.liveLabelOpacity = 0.0
    }
}

