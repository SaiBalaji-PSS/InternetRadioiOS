//
//  SearchCell.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import SwiftUI

struct SearchCell: View {
    let stationData: RadioStation
    var body: some View {
        HStack(alignment:.center,spacing:18){
            AsyncImage(url: URL(string: stationData.favicon ?? "")) { image in
                image
                    .resizable()
                   
                    .frame(width: 80,height: 80)
                    .aspectRatio(contentMode: .fill)
                  
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .frame(width: 80,height: 80)
            }.overlay {
                Rectangle()
                    .stroke(Color.black, lineWidth: 0.5)
                    .frame(width: 80,height: 80)
            }
            VStack(alignment:.leading,spacing: 4){
                Text(stationData.name?.uppercased() ?? "N/A")
                    .font(.custom("Avenir", size: 14))
                    .bold()
                    .multilineTextAlignment(.leading)
                Text("Votes \(stationData.votes ?? 0)")
                    .font(.custom("Avenir", size: 14))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }.frame(maxWidth: .infinity).padding(2).overlay(content: {
            Rectangle()
                .stroke(Color.gray, lineWidth: 1.0)
        }).padding(.horizontal,2)
    }
}

#Preview {
    SearchCell(stationData: RadioStation.mock)
}

extension RadioStation {
    static let mock = RadioStation(
        changeUuid: "823caf74-9e5c-45ec-a4f1-83fdb3647e74",
        stationUuid: "c7d2d51a-1d3f-46ed-bde9-e65722470109",
        name: "Suryan FM Chennai",
        url: "http://radios.crabdance.com:8002/3",
        urlResolved: "http://radios.crabdance.com:8002/3",
        homepage: "https://www.suryanfm.in/",
        favicon: "https://www.suryanfm.in/wp-content/uploads/2018/10/Header-icon.jpg",
        tags: "",
        country: "India",
        countryCode: "IN",
        iso3166_2: nil,
        state: "TAMIL NADU",
        language: "",
        languageCodes: "",
        votes: 38,
        lastChangeTime: "2026-03-08 00:38:18",
        lastChangeTimeISO8601: "2026-03-08T00:38:18Z",
        codec: "AAC+",
        bitrate: 128,
        hls: 0,
        lastCheckOK: 1,
        lastCheckTime: "2026-03-08 00:38:28",
        lastCheckTimeISO8601: "2026-03-08T00:38:28Z",
        lastCheckOKTime: "2026-03-08 00:38:28",
        lastCheckOKTimeISO8601: "2026-03-08T00:38:28Z",
        lastLocalCheckTime: "2026-03-08 00:38:28",
        lastLocalCheckTimeISO8601: "2026-03-08T00:38:28Z",
        clickTimestamp: "2026-08-07 09:08:51",
        clickCount: 1,
        clickTrend: 1,
        hasExtendedInfo: false
    )
}

