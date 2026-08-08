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
    @Published var isPlaying: Bool = false
    
    init(appState: AppState){
        self.appState = appState
        self.isPlaying = PlayerService.shared.isPlaying
    }
    func play(url: URL){
        PlayerService.shared.play(url: url)
        self.isPlaying = true
    }
    func pause(){
        PlayerService.shared.pause()
        self.isPlaying = false 
    }
    func close(){
        PlayerService.shared.stop()
        //now playing view will be hidden
        self.appState.shouldShowNowPlayingView = false
    }
}
