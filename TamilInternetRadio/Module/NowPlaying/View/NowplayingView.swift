//
//  NowplayingView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct NowplayingView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerService: PlayerService
    @StateObject private var vm: NowplayingViewModel
    
//    @State private var playbackObserver: NSObjectProtocol?
    
    init(appState: AppState,playerService: PlayerService){
        
        _vm = StateObject(wrappedValue: NowplayingViewModel(appState: appState, playerService: playerService))
    
    }
    var body: some View {
        HStack(spacing:28){
            AsyncImage(url: URL(string: appState.currentPlayingMedia?.favicon ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 25,height: 25)
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .frame(width: 25,height: 25)
            }
            VStack(alignment:.leading){
                Text("Now Playing")
                Text(appState.currentPlayingMedia?.name ?? "N/A")
                    .lineLimit(1)
                    .bold()
            }
            
            Button {
                if self.playerService.isPlaying{
                    self.vm.pause()
                }
                else{
                    if let url = appState.currentPlayingMedia?.url, let streamingUrl = URL(string: url){
                        self.vm.play(url: streamingUrl)
                    }
                }
            } label: {
                ZStack(alignment:.center){
                    Image(systemName: self.playerService.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 24,height:24)
                }
            }
            Spacer()
            Button {
                self.vm.close()
                self.appState.shouldShowNowPlayingView = false
            } label: {
                ZStack(alignment:.center){
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24,height: 24)
                        .foregroundStyle(.red)
                    
                    
                }
            }
            
        }.frame(maxWidth: .infinity).padding(.horizontal).padding(.vertical,6).glassEffect()
            .onAppear {
//                playbackObserver = NotificationCenter.default.addObserver(forName: .playbackStatusChanged, object: nil, queue: .main) { notification in
//                    guard let isPlaying = notification.userInfo?["isPlaying"] as? Bool else { return }
//                    Task { @MainActor in
//                        vm.isPlaying = isPlaying
//                    }
//                }
            }
            .onDisappear {
//                if let playbackObserver {
//                    NotificationCenter.default.removeObserver(playbackObserver)
//                    self.playbackObserver = nil
//                }
            }
    }
}

#Preview {
    NowplayingView(appState: AppState(),playerService: PlayerService())
        .environmentObject(AppState())
}
