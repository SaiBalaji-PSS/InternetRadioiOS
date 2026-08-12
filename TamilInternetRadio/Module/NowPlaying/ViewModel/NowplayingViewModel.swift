//
//  NowplayingViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine

@MainActor
class NowplayingViewModel: ObservableObject{
    let appState: AppState
    let playerService: PlayerService
  
    
    
    init(appState: AppState,playerService: PlayerService){
        self.appState = appState
        self.playerService = playerService
    
    }
    func play(url: URL){
        self.playerService.play(url: url)
        
    }
    func pause(){
        self.playerService.pause()
       
    }
    func close(){
        self.playerService.stop()
        //now playing view will be hidden
        self.appState.shouldShowNowPlayingView = false
    }
}
