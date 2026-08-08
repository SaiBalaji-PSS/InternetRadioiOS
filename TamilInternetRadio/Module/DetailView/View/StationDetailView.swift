//
//  StationDetailView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct StationDetailView: View {
    let stationData: RadioStation
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = StationDetailViewModel(service: NetworkService())
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: stationData.favicon ?? "")) { image in
                image
                    .resizable()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fill)
                  
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fill)

            }.overlay {
                Rectangle()
                    .stroke(Color.black, lineWidth: 0.5)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)

            }
            VStack(spacing:18){
                Text(stationData.name ?? "N/A")
                    .font(.largeTitle)
                    .bold()
                Text(stationData.state ?? "N/A")
                    .font(.title)
                Text(stationData.country ?? "N/A")
                    .font(.title)
                Text("Codec \(stationData.codec ?? "N/A")")
                    .font(.title)
                if stationData.bitrate != 0{
                    Text("Bit rate: \(stationData.bitrate ?? 0) kbps")
                        .font(.title)
                }
                
            }
            HStack(spacing:18){
                Button {
                    if self.vm.isPlaying{
                        self.vm.pause()
                    }
                    else{
                        if let stationUuid = stationData.stationUuid{
                            Task{
                                await self.vm.getResolvedUrl(for: stationUuid)
                                if self.vm.isPlaying{
                                    self.appState.currentPlayingMedia = stationData
                                }
                                
                            }
                        }
                    }
                    
                } label: {
                    ZStack(alignment:.center){
                        Circle()
                            .fill(.blue)
                            .frame(width: 70,height: 70)
                        Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                        
                }
                Button {
                    if let stationUuid = stationData.stationUuid{
                        self.vm.refresh(stationId: stationUuid)
                    }
                   
                } label: {
                    ZStack(alignment:.center){
                        Circle()
                            .fill(.blue)
                            .frame(width: 70,height: 70)
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                        
                }
                Spacer()
                HStack(spacing:8){
                    Circle()
                        .fill(.red)
                        .frame(width: 10,height: 10)
                    Text("Live")
                }

            }.padding()
            Spacer()
        }
        .alert("Info", isPresented: $vm.showMessage, actions: {
            Button("OK"){
                
            }
        },message: {
            Text(self.vm.message)
        })
        .onChange(of: vm.isPlaying) { oldValue, newValue in
            self.appState.shouldShowNowPlayingView = newValue
        }
        .onAppear {
            self.appState.isDetailScreenActive = true
        }
        .onDisappear {
            self.appState.isDetailScreenActive = false
        }
    }
}

#Preview {
    StationDetailView(stationData: RadioStation.mock)
        .environmentObject(AppState())
}
