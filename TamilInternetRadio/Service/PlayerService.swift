//
//  PlayerService.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import AVFoundation
import Combine

@MainActor
class AppState: ObservableObject{
    @Published var shouldShowNowPlayingView: Bool = false
    @Published var isDetailScreenActive: Bool = false
    @Published var currentPlayingMedia: RadioStation?
}
class PlayerService{
    static let shared = PlayerService()
    var isPlaying = false
    var player: AVPlayer?
    private init(){}
    
    func play(url: URL){
        self.player = AVPlayer(url: url)
        self.player?.play()
        self.isPlaying = true
    }
    
    func pause(){
        if let player{
            player.pause()
            self.isPlaying = false
        }
    }
    
    func stop(){
        player = nil
        self.isPlaying = false
    }
    
    

    
    
}
