//
//  SearchView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

enum Field{
    case searchField
}
struct SearchView: View {
    @StateObject private var vm = SearchViewModel(service: NetworkService())
    @FocusState private var searchField: Field?
    @State var shouldNavigateToDetail: Bool = false
    @State var selectedStation: RadioStation?
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerService: PlayerService
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView(.vertical) {
                    LazyVStack{
                        ForEach(self.vm.searchResult,id:\.id){ searchResult in
                            SearchCell(stationData: searchResult).contentShape(Rectangle())
                                .onTapGesture {
                                    self.selectedStation = searchResult
                                    self.shouldNavigateToDetail = true
                                    
                                }
                            
                            
                        }
                    }
                }
                if vm.showNoResultView{
                    VStack(spacing:28){
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 100,height: 100)
                        Text("No search result found for \(self.vm.searchText)")
                    }.frame(maxWidth: .infinity,maxHeight: .infinity).background(.white)
                }
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText,prompt: "Search by Radio Station name")
            .searchFocused($searchField, equals: .searchField)
            .alert("Info", isPresented: $vm.showMessage, actions: {
                Button("OK"){
                    
                }
            }, message: {
                Text(vm.message)
            })
            .task(id: vm.searchText, {
                try? await Task.sleep(nanoseconds: 500_000_000)
                await self.vm.searchRadioStation()
                
            })
            .toolbar(content: {
                ToolbarItem(placement: .keyboard) {
                    Button("Done"){
                        searchField = nil
                    }
                }
            })
            .navigationTitle("Search")
            
            .navigationDestination(isPresented: $shouldNavigateToDetail) {
                if let selectedStation{
                    StationDetailView(playerService: playerService, stationData: selectedStation)
                }
            }
        }
        
    }
}

#Preview {
    SearchView()
        .environmentObject(AppState())
}
