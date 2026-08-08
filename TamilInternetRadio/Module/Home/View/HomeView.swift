//
//  HomeView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 06/08/26.
//

import SwiftUI
import AVKit

struct HomeView: View {
    @State private var player: AVPlayer?
    @StateObject private var vm = HomeViewModel(service: NetworkService())
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 120))]){
                    
                    ForEach(vm.radioStations,id:\.id) { data in
                        RadioCellView(radioItem: data)
                    }
                }
            }
            .navigationTitle("All Stations")
        }
        .task {
           await self.vm.getAllTamilStations()
            
        }
    }
}

#Preview {
    HomeView()
}
