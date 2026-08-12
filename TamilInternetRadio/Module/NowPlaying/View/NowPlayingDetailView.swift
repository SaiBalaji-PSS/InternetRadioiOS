//
//  NowPlayingDetailView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 09/08/26.
//

import SwiftUI

struct NowPlayingDetailView: View {
    @StateObject private var vm: NowPlayingDetailViewModel
   
    let playingItem: RadioStation
   
    @Environment(\.dismiss) var dismiss
    init(appState: AppState,playingItem: RadioStation,playerService: PlayerService){
        _vm = StateObject(wrappedValue: NowPlayingDetailViewModel(appState: appState, playerService: playerService, networkSerivce: NetworkService()))
        self.playingItem = playingItem
    }
    var body: some View {
        VStack(spacing: 8){
           
            AsyncImage(url: URL(string: playingItem.favicon ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 200,height: 200)
                    .aspectRatio(contentMode: .fit)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius:16).stroke(.gray, lineWidth: 1)
                            .frame(width: 200,height: 200)
                            
                            
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 6.0,x:6.0,y:6.0)
                    .shadow(radius: 6.0,x:6.0,y:12.0)
                    .padding()
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .aspectRatio(contentMode: .fit)
                    .overlay(content: {
                        Rectangle().stroke(.gray, lineWidth: 1)
                            .frame(width: 200,height: 200)
                            
                            
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 6.0,x:6.0,y:6.0)
                    .shadow(radius: 6.0,x:6.0,y:12.0)
                    .padding()
                
            }
            Text(playingItem.name ?? "")
                .bold()
                .font(.title)
            Text(playingItem.country ?? "")
                .font(.title2)
            Text(playingItem.codec ?? "")
                .bold()
                .font(.title)
            
            HStack(){
                Button {
                    Task{
                        await self.vm.resolveUrl(item: self.playingItem)
                    }
                } label: {
                    ZStack{
                        Circle()
                            .fill(.blue)
                            .frame(width: 70,height: 70)
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundStyle(.black)
                    }
                }
                Spacer()
                Button {
                    if self.vm.isPlaying{
                        self.vm.pause()
                    }
                    else{
                        Task{
                            await self.vm.resolveUrl(item: self.playingItem)
                        }
                    }
                } label: {
                    ZStack{
                        Circle()
                            .fill(.blue)
                            .frame(width: 70,height: 70)
                        Image(systemName: self.vm.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundStyle(.black)
                    }
                }
                
                Spacer()
                Button {
                    
                } label: {
                    ZStack{
                        Circle()
                            .fill(.blue)
                            .frame(width: 70,height: 70)
                        Image(systemName: "airplayaudio")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundStyle(.black)
                    }
                }

            }.frame(maxWidth: .infinity).padding()
            Spacer()
            HStack{
               Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 50,height: 50)
                }
                Spacer()

            }.padding()
            Spacer()
        }
    }
}

#Preview {
    NowPlayingDetailView(appState: AppState(), playingItem: RadioStation.mock, playerService: PlayerService())
}
