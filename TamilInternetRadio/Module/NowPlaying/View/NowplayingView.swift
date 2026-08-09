//
//  NowplayingView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct NowplayingView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject private var vm: NowplayingViewModel
    
    init(appState: AppState){
        _vm = StateObject(wrappedValue: NowplayingViewModel(appState: appState))
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
                if vm.isPlaying{
                    self.vm.pause()
                }
                else{
                    if let url = appState.currentPlayingMedia?.url, let streamingUrl = URL(string: url){
                        self.vm.play(url: streamingUrl)
                    }
                }
            } label: {
                ZStack(alignment:.center){
                    Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
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
    }
}

#Preview {
    NowplayingView(appState: AppState())
        .environmentObject(AppState())
}
