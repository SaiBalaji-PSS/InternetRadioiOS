//
//  StatinoDetailView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 11/08/26.
//

import SwiftUI

struct StationDetailView: View {
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var playerServiceObject: PlayerService
    @StateObject private var vm: StationDetailViewModel
    
    let stationData: RadioStation
    
    init(playerService: PlayerService,stationData: RadioStation){
        
        self.stationData = stationData
        _vm = StateObject(wrappedValue: StationDetailViewModel(service: NetworkService(), playerService: playerService))
    }
  

    @State private var timer: Timer?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing:18){
            HStack{
                Spacer()
                CustomPlayerButton(buttonImageName: vm.saveSuccess ? "heart.fill" : "heart", xOffset: 0.0) {
                    if self.vm.saveSuccess{
                        //already saved then remove from favorite
                        self.vm.removeFromFavorite(radioStation: self.stationData)
                    }
                    else{
                        self.vm.saveRadioStationToLibrary(radioStation: self.stationData)
                    }
                }.padding()
            }
            AsyncImage(url: URL(string: stationData.favicon ?? "")) { image  in
                image
                    .resizable()
                    .frame(width: 200,height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .padding()
                    .glassEffect(.regular.interactive(),in: .rect)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .shadow(radius: 6.0,x:3,y:3)
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .padding()
                    .glassEffect(.regular.interactive(),in: .rect)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .shadow(radius: 6.0,x:3,y:3)
            }
            HStack{
                VStack(alignment:.leading,spacing:8){
                    Text(stationData.name ?? "")
                        .bold()
                        .font(.title2)
                    Text(stationData.country ?? "")
                        .font(.title3)
                    Text(stationData.codec ?? "")
                        .font(.subheadline)
                        .italic()
                }
                Spacer()
                HStack{
                    Circle()
                        .fill(.red)
                        .frame(width: 10,height: 10)
                    Text("LIVE")
                        .bold()
                }.opacity(self.vm.liveLabelOpacity)
                
                
            }.padding()
            
            HStack{
                
                
                
                CustomPlayerButton(buttonImageName: "arrow.clockwise", xOffset: 0.0) {
                    if let stationId = stationData.stationUuid{
                        Task{
                            await self.vm.refresh(stationId: stationId)
                            if self.vm.isPlaying{
                                self.appState.currentPlayingMedia = stationData
                                self.appState.shouldShowNowPlayingView = true
                            }
                        }
                    }
                }
                
                Spacer()
                
                CustomPlayerButton(buttonImageName: self.vm.isPlaying ? "pause.fill" : "play.fill", xOffset: self.vm.isPlaying ? 0 : 3) {
                    
                    if self.vm.isPlaying{
                        
                      
                        
                        
                        self.vm.pause()
                    }
                    else{
                       
                        
                        if let stationId = stationData.stationUuid{
                            Task{
                                await self.vm.getResolvedUrl(for: stationId)
                                if self.vm.isPlaying{
                                    self.appState.currentPlayingMedia = stationData
                                    self.appState.shouldShowNowPlayingView = true
                                }
                                

                            }
                            
                        }
                    }
                }
                
                Spacer()
                CustomPlayerButton(buttonImageName: "airplay.audio", xOffset: 0.0) {
                    
                }
                
                
                
            }.padding()
           
            HStack{
                Spacer()
                CustomPlayerButton(buttonImageName: "xmark", xOffset: 0.0) {
                    self.dismiss()
                }
                Spacer()
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
        .alert("Sora Radio", isPresented: $vm.showMessage, actions: {
            Button("OK"){
                
            }
        },message: {
            Text(vm.message)
        })
        .onAppear(perform: {
            
            self.appState.isDetailScreenActive = true
            self.vm.checkIfStationIsAlreadySaved(radioStation: self.stationData)
            print("ON APPEAR CALLED \(self.appState.currentPlayingMedia?.name)")
            
            //This is needed to check if the station played in the app currently is same as the search tap navigation station. If true then only we need to pre populate the play/pause button status. If they are not equal then no need to pre populate the UI with play pause status
           
            if self.stationData.stationUuid == self.appState.currentPlayingMedia?.stationUuid{
                self.vm.isPlaying = self.playerServiceObject.isPlaying
                if  self.vm.isPlaying{
                    
                    self.vm.startLiveLabelBlinking()
                }
                else{
                    self.vm.stopLiveLabelBlinking()
                }
            }
        })
        .onDisappear {
            self.appState.isDetailScreenActive = false
            self.vm.stopLiveLabelBlinking()
        }
        
        
    }
}

#Preview {
    StationDetailView(playerService: PlayerService(), stationData: RadioStation.mock)
        .environmentObject(AppState())
        .environmentObject(PlayerService())
}
