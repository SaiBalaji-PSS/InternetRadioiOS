//
//  MainTabbarView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct MainTabbarView: View {
    @StateObject private var appState = AppState()
    @StateObject private var playerService = PlayerService()
    @State var isPlayerDetialPresented: Bool = false
    var body: some View {
        ZStack(alignment:.bottom){
            TabView {
                Tab("Search", systemImage: "magnifyingglass", content: {
                    SearchView()
                        .environmentObject(appState)
                        .environmentObject(playerService)
                })
                Tab("Library",systemImage: "radio") {
                    LibraryView()
                        .environmentObject(appState)
                        .environmentObject(playerService)
                }
                
            }
            if self.appState.shouldShowNowPlayingView && !self.appState.isDetailScreenActive{
                //now playing bottom  view
                NowplayingView(appState: appState, playerService: playerService)
                    .padding(.bottom,50)
                    .environmentObject(appState)
                    .environmentObject(playerService)
                    .onTapGesture {
                        isPlayerDetialPresented = true 
                    }
            }
                
        }.fullScreenCover(isPresented: $isPlayerDetialPresented) {
            if let currentPlayingMedia = self.appState.currentPlayingMedia{
                StationDetailView(playerService: playerService,stationData: currentPlayingMedia)
                    .environmentObject(appState)
                    .environmentObject(playerService)
            }
        }
        
    }
}

#Preview {
    MainTabbarView()
}
