//
//  LibraryView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var vm = LibraryViewModel(persistenceController: LibraryPersistenceController(),networkService: NetworkService())
    @State private var shouldNavigateToDetailScreen: Bool = false
    @State private var selectedRadioStation: SavedRadioStation?
    @EnvironmentObject var playerService: PlayerService
    
   
    
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 100, maximum: 100),spacing:28)]){
                    ForEach(vm.savedStations,id:\.id){ data in
                        LibraryItemCell(libraryItem: data)
                            .onTapGesture {
                                self.selectedRadioStation = data
                                if let selectedRadioStationId = selectedRadioStation?.stationId{
                                    Task{
                                        await vm.getStationInfo(id: selectedRadioStationId)
                                        self.shouldNavigateToDetailScreen = true
                                    }
                                }
                              
                            }
                    }
                }
            }
            .fullScreenCover(isPresented: $shouldNavigateToDetailScreen, content: {
                if let stationData =  vm.stationData{
                    StationDetailView(playerService: playerService, stationData: stationData)
                }
            })
            
                .onAppear {
                    vm.fetchAllSavedStations()
                    
                }
               
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(PlayerService())
}
