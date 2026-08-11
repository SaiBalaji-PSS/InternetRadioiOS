//
//  StationModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 06/08/26.
//

import Foundation


struct RadioStation: Codable, Identifiable {
    let id = UUID()
    let changeUuid: String?
    let stationUuid: String?
    let name: String?
    let url: String?
    let urlResolved: String?
    let homepage: String?
    let favicon: String?
    let tags: String?
    let country: String?
    let countryCode: String?
    let iso3166_2: String?
    let state: String?
    let language: String?
    let languageCodes: String?
    let votes: Int?
    let lastChangeTime: String?
    let lastChangeTimeISO8601: String?
    let codec: String?
    let bitrate: Int?
    let hls: Int?
    let lastCheckOK: Int?
    let lastCheckTime: String?
    let lastCheckTimeISO8601: String?
    let lastCheckOKTime: String?
    let lastCheckOKTimeISO8601: String?
    let lastLocalCheckTime: String?
    let lastLocalCheckTimeISO8601: String?
    let clickTimestamp: String?
    let clickCount: Int?
    let clickTrend: Int?
    let hasExtendedInfo: Bool?

    enum CodingKeys: String, CodingKey {
        case changeUuid = "changeuuid"
        case stationUuid = "stationuuid"
        case name
        case url
        case urlResolved = "url_resolved"
        case homepage
        case favicon
        case tags
        case country
        case countryCode = "countrycode"
        case iso3166_2 = "iso_3166_2"
        case state
        case language
        case languageCodes = "languagecodes"
        case votes
        case lastChangeTime = "lastchangetime"
        case lastChangeTimeISO8601 = "lastchangetime_iso8601"
        case codec
        case bitrate
        case hls
        case lastCheckOK = "lastcheckok"
        case lastCheckTime = "lastchecktime"
        case lastCheckTimeISO8601 = "lastchecktime_iso8601"
        case lastCheckOKTime = "lastcheckoktime"
        case lastCheckOKTimeISO8601 = "lastcheckoktime_iso8601"
        case lastLocalCheckTime = "lastlocalchecktime"
        case lastLocalCheckTimeISO8601 = "lastlocalchecktime_iso8601"
        case clickTimestamp = "clicktimestamp"
        case clickCount = "clickcount"
        case clickTrend = "clicktrend"
        case hasExtendedInfo = "has_extended_info"
    }
}
