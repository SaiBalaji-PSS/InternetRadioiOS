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
    @Published var showNoResultView: Bool = false
    @Published var showMessage: Bool = false
    @Published var message: String = ""
    private let service: NetworkServiceProtocol
    init(service: NetworkServiceProtocol){
        self.service = service
    }
    
    func searchRadioStation()async{
        if self.searchText.isEmpty == false{
            do{
                let result: [RadioStation] = try await self.service.performRequest(endPoint: .search(name: self.searchText), body: nil as String?)
                self.searchResult = result
                self.showNoResultView = self.searchResult.isEmpty
            }
            catch{
                if let urlError = error as? URLError, urlError.code == .cancelled {
                    // this is a cancellation, ignore it
                    self.showMessage = false
                    self.showNoResultView = false 
                    return
                }
                self.message = error.localizedDescription
                self.showMessage = true
                self.showNoResultView = false
            }
        }
        else{
            self.searchResult = []
            self.showMessage = false
            self.showNoResultView = false
        }
    }
}
