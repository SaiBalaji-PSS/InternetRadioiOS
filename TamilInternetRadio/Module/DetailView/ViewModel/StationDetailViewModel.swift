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
    var timer: Timer?
    
    private let service: NetworkServiceProtocol
//    let stationUrlOverrides: [String: String] = [
//        "f4092372-9aac-4af6-8067-4d1c59ea4530": "https://radios.crabdance.com:8002/4" // big fm
//    ]
    
    init(service: NetworkServiceProtocol){
        self.service = service
    }
    
    func getResolvedUrl(for stationId: String)async{
//        if let stationUrl = stationUrlOverrides[stationId]{
//            if let streamingUrl = URL(string: stationUrl){
//                self.play(url: streamingUrl)
//                self.isPlaying = PlayerService.shared.isPlaying
//            }
//            return
//        }
        do{
            let result: StationUrlModel = try await self.service.performRequest(endPoint: .streamingUrl(stationId: stationId), body: nil as String?)
            if result.ok{
                if let url = result.url, let streamingURL = URL(string: url){
                    self.play(url: streamingURL)
                    self.isPlaying = PlayerService.shared.isPlaying
                }
                else{
                    self.showMessage = true
                    self.message = "Invalid streaming url"
                    self.isPlaying = false
                }
            }
            else{
                self.showMessage = true
                self.message = "An error occured while resolving the streaming url"
                self.isPlaying = false
            }
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
            self.isPlaying = false
        }
    }
    func play(url: URL){
        PlayerService.shared.play(url: url)
        self.startLiveLabelBlinking()
    }
    func pause(){
        PlayerService.shared.pause()
        self.isPlaying = PlayerService.shared.isPlaying
        self.stopLiveLabelBlinking()
    }
    //Stops the current play, refreshes streaming url
    func refresh(stationId: String)async {
        PlayerService.shared.stop()
        self.isPlaying = PlayerService.shared.isPlaying
        await self.getResolvedUrl(for: stationId)
        
    }
    
    func saveRadioStationToLibrary(radioStation: RadioStation){
        let radioStationData = SavedRadioStation(context: PersistenceController.shared.context)
        radioStationData.stationId = radioStation.stationUuid
        radioStationData.title = radioStation.name
        if let imageURLString = radioStation.favicon, let imageURL = URL(string:imageURLString){
            radioStationData.imageUrl = imageURL
        }
        do{
            try PersistenceController.shared.saveData()
            self.saveSuccess = true 
        }
        catch{
            print(error)
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

