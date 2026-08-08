//
//  SearchView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel(service: NetworkService())
    
    var body: some View {
        NavigationStack{
            
                ScrollView(.vertical) {
                    LazyVStack{
                        ForEach(self.vm.searchResult,id:\.id){ searchResult in
                            NavigationLink(destination: {
                                StationDetailView(stationData: searchResult)
                            }, label: {
                                SearchCell(stationData: searchResult)
                            })
                           
                           
                        }
                    }.animation(.easeIn, value: vm.searchResult.map{$0.id})
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText,prompt: "Search by Radio Station name")
            .task(id: vm.searchText, {
                try? await Task.sleep(nanoseconds: 500_000_000)
                await self.vm.searchRadioStation()
                
            })
            .navigationTitle("Search")
        }
        
    }
}

#Preview {
    SearchView()
}
