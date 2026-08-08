//
//  SearchViewModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import Combine


@MainActor
class SearchViewModel: ObservableObject{
    @Published var searchResult = [RadioStation]()
    @Published var searchText: String = ""
    private let service: NetworkServiceProtocol
    init(service: NetworkServiceProtocol){
        self.service = service
    }
    
    func searchRadioStation()async{
        if self.searchText.isEmpty == false{
            do{
                let result: [RadioStation] = try await self.service.performRequest(endPoint: .search(name: self.searchText), body: nil as String?)
                self.searchResult = result
            }
            catch{
                print(error)
            }
        }
        else{
            self.searchResult = []
        }
    }
}
