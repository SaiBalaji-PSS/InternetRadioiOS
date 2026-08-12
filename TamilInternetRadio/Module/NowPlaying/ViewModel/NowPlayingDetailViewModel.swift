//
//  NowPlayingDetailViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 09/08/26.
//

import Foundation
import Combine

class NowPlayingDetailViewModel: ObservableObject{
    

    @Published var isPlaying: Bool = false
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    private var appState: AppState
    private let networkSerivce: NetworkServiceProtocol
    private let playerService: PlayerService
    
    init(appState: AppState,playerService: PlayerService,networkSerivce: NetworkServiceProtocol){
        self.appState = appState
        self.playerService = playerService
        self.networkSerivce = networkSerivce
    }

//    let stationUrlOverrides: [String: String] = [
//        "f4092372-9aac-4af6-8067-4d1c59ea4530": "https://radios.crabdance.com:8002/4" // big fm
//    ]
    
    private func play(url: URL,item: RadioStation){
        
        if let streamingUrlString = item.urlResolved, let streamingUrl = URL(string: streamingUrlString){
            self.playerService.play(url: streamingUrl)
            self.appState.currentPlayingMedia = item
        }
    }
    
    func resolveUrl(item: RadioStation)async {
//        if let existingUrl = stationUrlOverrides[item.stationUuid ?? ""], let streamingUrl = URL(string: existingUrl){
//            self.play(url: streamingUrl, item: item)
//            return
//        }
        do{
            if let stationUuid = item.stationUuid{
                let result: StationUrlModel = try await self.networkSerivce.performRequest(endPoint: .streamingUrl(stationId: stationUuid), body: nil as String?)
                
                if let urlString = result.url, let streamingUrl = URL(string: urlString){
                    self.play(url: streamingUrl, item: item)
                }
            }
        }
        catch{
            self.showMessage = true
            self.message = error.localizedDescription
        }
    }
    
    func pause(){
        self.playerService.pause()
    }
}
