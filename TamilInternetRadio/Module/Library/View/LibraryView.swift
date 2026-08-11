//
//  LibraryView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var vm = LibraryViewModel(persistenceController: LibraryPersistenceController())
    @State private var shouldNavigateToDetailScreen: Bool = false
    @State private var selectedRadioStation: SavedRadioStation?
    var body: some View {
        
        NavigationStack{
            ScrollView{
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 100, maximum: 100),spacing:28)]){
                    ForEach(vm.savedStations,id:\.id){ data in
                        LibraryItemCell(libraryItem: data)
                            .onTapGesture {
                                self.selectedRadioStation = data
                                self.shouldNavigateToDetailScreen = true
                            }
                    }
                }
            }
            .fullScreenCover(isPresented: $shouldNavigateToDetailScreen, content: {
                if let selectedRadioStation{
                  //  StationDetailView(stationData: <#T##RadioStation#>)
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
}
