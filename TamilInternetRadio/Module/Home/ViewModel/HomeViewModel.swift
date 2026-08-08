//
//  HomeViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 06/08/26.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    @Published var radioStations = [RadioStation]()
    @Published var message: String = ""
    @Published var showMessage: Bool = false
    private var service: NetworkServiceProtocol
    init(service: NetworkServiceProtocol){
        self.service = service
    }
    
    
    func getAllTamilStations()async{
        do{
            let result: [RadioStation] = try await self.service.performRequest(endPoint: .allStations, body: nil as String?)
            self.radioStations = result
        }
        catch{
            print(error)
            self.showMessage = true
            self.message = error.localizedDescription
        }
    }
}
