//
//  LibraryView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var vm = LibraryViewModel(persistenceController: LibraryPersistenceController())
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 100, maximum: 100),spacing:28)]){
                    ForEach(vm.savedStations,id:\.id){ data in
                        LibraryItemCell(libraryItem: data)
                    }
                }
            }
                .onAppear {
                    vm.fetchAllSavedStations()
                }
        }
    }
}

#Preview {
    LibraryView()
}
