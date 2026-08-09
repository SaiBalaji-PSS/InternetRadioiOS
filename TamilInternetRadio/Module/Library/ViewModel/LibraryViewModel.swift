//
//  LibraryViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine
import CoreData


class LibraryViewModel: ObservableObject{
    @Published var savedStations = [SavedRadioStation]()
    @Published var showMessage: Bool = false
    @Published var message = ""
    private let persistenceController: PersistenceProtocol
    
    init(persistenceController: PersistenceProtocol){
        self.persistenceController = persistenceController
    }
    
    func fetchAllSavedStations(){
        do{
            let result: [SavedRadioStation] = try self.persistenceController.fetchAllData(from: "SavedRadioStation")
            self.savedStations = result
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
        }
    }
}
