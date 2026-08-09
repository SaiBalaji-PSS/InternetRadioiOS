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


extension RadioStation {
    static let mockArray: [RadioStation] = [
        .mock,
        RadioStation(
            changeUuid: "1a2b3c4d-5e6f-4a1b-9c2d-3e4f5a6b7c8d",
            stationUuid: "2b3c4d5e-6f7a-4b2c-8d3e-4f5a6b7c8d9e",
            name: "Big FM Tamil",
            url: "https://stream.zeno.fm/r2gn1pgm4qruv",
            urlResolved: "https://stream.zeno.fm/r2gn1pgm4qruv",
            homepage: "",
            favicon: "https://onlineradiohub.com/wp-content/uploads/2023/02/big-fm-tamil.jpg",
            tags: "",
            country: "India",
            countryCode: "IN",
            iso3166_2: nil,
            state: "",
            language: "tamil",
            languageCodes: "ta",
            votes: 925,
            lastChangeTime: "2026-01-15 07:58:24",
            lastChangeTimeISO8601: "2026-01-15T07:58:24Z",
            codec: "MP3",
            bitrate: 0,
            hls: 0,
            lastCheckOK: 1,
            lastCheckTime: "2026-01-15 07:58:24",
            lastCheckTimeISO8601: "2026-01-15T07:58:24Z",
            lastCheckOKTime: "2026-01-15 07:58:24",
            lastCheckOKTimeISO8601: "2026-01-15T07:58:24Z",
            lastLocalCheckTime: "2026-01-15 07:58:24",
            lastLocalCheckTimeISO8601: "2026-01-15T07:58:24Z",
            clickTimestamp: "2026-08-09 03:32:16",
            clickCount: 7,
            clickTrend: 7,
            hasExtendedInfo: false
        ),
        RadioStation(
            changeUuid: "3c4d5e6f-7a8b-4c3d-9e4f-5a6b7c8d9e0f",
            stationUuid: "4d5e6f7a-8b9c-4d4e-0f5a-6b7c8d9e0f1a",
            name: "Hello FM 106.4",
            url: "http://peridot.streamguys.com:7150/HFM",
            urlResolved: "http://peridot.streamguys.com:7150/HFM",
            homepage: "https://www.hellofm.in/",
            favicon: "https://www.hellofm.in/favicon.ico",
            tags: "tamil,music",
            country: "India",
            countryCode: "IN",
            iso3166_2: nil,
            state: "TAMIL NADU",
            language: "tamil",
            languageCodes: "ta",
            votes: 210,
            lastChangeTime: "2026-02-11 12:20:00",
            lastChangeTimeISO8601: "2026-02-11T12:20:00Z",
            codec: "MP3",
            bitrate: 128,
            hls: 0,
            lastCheckOK: 1,
            lastCheckTime: "2026-02-11 12:20:10",
            lastCheckTimeISO8601: "2026-02-11T12:20:10Z",
            lastCheckOKTime: "2026-02-11 12:20:10",
            lastCheckOKTimeISO8601: "2026-02-11T12:20:10Z",
            lastLocalCheckTime: "2026-02-11 12:20:10",
            lastLocalCheckTimeISO8601: "2026-02-11T12:20:10Z",
            clickTimestamp: "2026-08-08 14:02:41",
            clickCount: 4,
            clickTrend: 2,
            hasExtendedInfo: false
        ),
        RadioStation(
            changeUuid: "5e6f7a8b-9c0d-4e5f-1a6b-7c8d9e0f1a2b",
            stationUuid: "6f7a8b9c-0d1e-4f6a-2b7c-8d9e0f1a2b3c",
            name: "No Signal Test Station",
            url: "",
            urlResolved: nil,
            homepage: "",
            favicon: "",
            tags: "",
            country: "India",
            countryCode: "IN",
            iso3166_2: nil,
            state: "",
            language: "",
            languageCodes: "",
            votes: 0,
            lastChangeTime: "2025-12-01 00:00:00",
            lastChangeTimeISO8601: "2025-12-01T00:00:00Z",
            codec: "",
            bitrate: 0,
            hls: 0,
            lastCheckOK: 0,
            lastCheckTime: "2025-12-01 00:00:00",
            lastCheckTimeISO8601: "2025-12-01T00:00:00Z",
            lastCheckOKTime: "2025-12-01 00:00:00",
            lastCheckOKTimeISO8601: "2025-12-01T00:00:00Z",
            lastLocalCheckTime: "2025-12-01 00:00:00",
            lastLocalCheckTimeISO8601: "2025-12-01T00:00:00Z",
            clickTimestamp: "2025-12-01 00:00:00",
            clickCount: 0,
            clickTrend: 0,
            hasExtendedInfo: false
        )
    ]
}
