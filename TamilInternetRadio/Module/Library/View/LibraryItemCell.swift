//
//  LibraryItemCell.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI
import CoreData

// LibraryItemCell.swift
struct LibraryItemCell: View {
    let libraryItem: SavedRadioStation
    var body: some View {
        VStack {
            AsyncImage(url: libraryItem.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipped()
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipped()
            }
            Text(libraryItem.title ?? "N/A")
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 120,height: 120) // cell width
        .background(
            RoundedRectangle(cornerRadius: 6.0)
                       .fill(Color.white)
               )
               .overlay(
                RoundedRectangle(cornerRadius: 6.0)
                       .stroke(Color.gray.opacity(0.3), lineWidth: 1)
               )
               .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    LibraryItemCell(libraryItem: SavedRadioStation.mock)
}

extension SavedRadioStation {
    static var mock: SavedRadioStation {
        
        let station = SavedRadioStation(context: PersistenceController.shared.context)
        station.title = "Suryan FM Chennai"
        station.stationId = "9617a958-0601-11e8-ae97-52543be04c81"
        station.imageUrl = URL(string: "https://www.suryanfm.in/wp-content/uploads/2018/10/Header-icon.jpg")
        return station
    }
}
