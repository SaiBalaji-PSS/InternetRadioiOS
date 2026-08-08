//
//  StationDetailViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine
import AVFoundation


@MainActor
class StationDetailViewModel: ObservableObject{
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    @Published var isPlaying: Bool = false
    private let service: NetworkServiceProtocol
    init(service: NetworkServiceProtocol){
        self.service = service
    }
    
    func getResolvedUrl(for stationId: String)async{
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
    }
    func pause(){
        PlayerService.shared.pause()
        self.isPlaying = PlayerService.shared.isPlaying
    }
    //Stops the current play, refreshes streaming url
    func refresh(stationId: String){
        PlayerService.shared.stop()
        self.isPlaying = PlayerService.shared.isPlaying
        Task{
            await self.getResolvedUrl(for: stationId)
        }
    }
}
