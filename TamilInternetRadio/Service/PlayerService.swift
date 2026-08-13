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
    var playerItem: AVPlayerItem?
    
     init(){
        
        do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
               try AVAudioSession.sharedInstance().setActive(true)
           } catch {
               print("Failed to set up audio session: \(error)")
           }
        
    }
    
    func play(url: URL){
        self.removeObservers()
        self.playerItem = AVPlayerItem(url: url)
        if let playerItem{
            self.addNotificationObserver(item: playerItem)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.play()
            self.isPlaying = true
        }
    }
    
    func addNotificationObserver(item: AVPlayerItem){
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayBackFail), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayBackStall), name: .AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInteruption(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: nil)
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
        self.removeObservers()
      //  NotificationCenter.default.post(name: .playbackStatusChanged, object: nil, userInfo: ["isPlaying": false])
    }
    
    @objc func didPlayBackFail(){
        self.isPlaying = false
        self.stop()
        print("HANDLE PLAY BACK FAIL NOTIFICATION")
    }
    
    @objc func didPlayBackStall(){
        self.isPlaying = false
        self.stop()
        print("HANDLE PLAY BACK STALL NOTIFICATION")
    }
    @objc func handleAudioInteruption(_ notification: Notification){
        print("HANDLE INTERUPTION NOTIFICATION")
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        
        // Switch over the interruption type.
        switch type {
            
            
        case .began:
            // An interruption began. Update the UI as necessary.
            print("HANDLE INTERUPTION NOTIFICATION PAUSED")
            self.pause()
            
        case .ended:
            // An interruption ended. Resume playback, if appropriate.
            
            
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // An interruption ended. Resume playback.
            } else {
                // An interruption ended. Don't resume playback.
            }
            
            
        default: ()
        }
    }
    
}



