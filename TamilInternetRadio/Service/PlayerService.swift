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

    @Published var shouldShowNowPlayingView: Bool = false //this is used to show and hide floaing bottom player
    @Published var isDetailScreenActive: Bool = false
    @Published var currentPlayingMedia: RadioStation? //this will be used to populate bottom floaing player media details
    @Published var isMediaPlayingInApp: Bool = false
}


class PlayerService: ObservableObject {
    
    @Published var isPlaying = false
    var player: AVPlayer?
     init(){
        
        do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
               try AVAudioSession.sharedInstance().setActive(true)
           } catch {
               print("Failed to set up audio session: \(error)")
           }
        
    }
    
    func play(url: URL){
        self.player = AVPlayer(url: url)
        self.player?.play()
        self.isPlaying = true
       // NotificationCenter.default.post(name: .playbackStatusChanged, object: nil, userInfo: ["isPlaying": true])
    }
    
    func pause(){
        if let player {
            player.pause()
            self.isPlaying = false
          //  NotificationCenter.default.post(name: .playbackStatusChanged, object: nil, userInfo: ["isPlaying": false])
        }
    }
    
    func stop(){
        player = nil
        self.isPlaying = false
      //  NotificationCenter.default.post(name: .playbackStatusChanged, object: nil, userInfo: ["isPlaying": false])
    }
}



