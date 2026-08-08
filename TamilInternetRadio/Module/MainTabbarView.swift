//
//  MainTabbarView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct MainTabbarView: View {
    @StateObject private var appState = AppState()
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
                    Text("Library")
                        .environmentObject(appState)
                }
                
            }
            if self.appState.shouldShowNowPlayingView && !self.appState.isDetailScreenActive{
                //now playing view
                NowplayingView(appState: appState)
                    .padding(.bottom,50)
                    .environmentObject(appState)
            }
        }
        
    }
}

#Preview {
    MainTabbarView()
}
