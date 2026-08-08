//
//  StationUrlModel.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation

struct StationUrlModel: Codable {
    let ok: Bool
    let message: String?
    let stationuuid: String?
    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case ok = "ok"
        case message = "message"
        case stationuuid = "stationuuid"
        case name = "name"
        case url = "url"
    }
}
