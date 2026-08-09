//
//  MainTabbarView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct MainTabbarView: View {
    @StateObject private var appState = AppState()
    @State var isPlayerDetialPresented: Bool = false
    var body: some View {
        ZStack(alignment:.bottom){
            TabView {
                Tab("Home",systemImage: "house") {
                    HomeView()
                        .environmentObject(appState)
                }
                Tab("Search", systemImage: "magnifyingglass", content: {
                    SearchView()
                        .environmentObject(appState)
                })
                Tab("Library",systemImage: "radio") {
                    LibraryView()
                        .environmentObject(appState)
                }
                
            }
            if self.appState.shouldShowNowPlayingView && !self.appState.isDetailScreenActive{
                //now playing view
                NowplayingView(appState: appState)
                    .padding(.bottom,50)
                    .environmentObject(appState)
                    .onTapGesture {
                        isPlayerDetialPresented = true 
                    }
            }
                
        }.fullScreenCover(isPresented: $isPlayerDetialPresented) {
            if let currentPlayingMedia = self.appState.currentPlayingMedia{
                NowPlayingDetailView(appState: appState,playingItem: currentPlayingMedia)
            }
        }
        
    }
}

#Preview {
    MainTabbarView()
}
