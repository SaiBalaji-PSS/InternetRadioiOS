//
//  NetworkService.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 06/08/26.
//

import Foundation

struct Constant{
    static let BASE_URL = "https://de1.api.radio-browser.info/json/"
}

enum HttpMethod: String{
    case GET = "GET"
}
enum NetworkServiceError: LocalizedError{
    case invalidUrl(url: String)
    case invalidStatus(code: Int)
    case invalidResponse
    
    var errorDescription: String?{
        switch self {
        case .invalidUrl(let url):
            return "Invalid URL: \(url)"
        case .invalidStatus(code: let code):
            return "Invalid status code: \(code)"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}
protocol EndPointProtocol{
    var baseURL: URL{get }
    var endPoint: String{get }
    var method: HttpMethod{get }
    var headers: [String:String]{get }
    var queryItem: [URLQueryItem]{get }
}
extension EndPointProtocol{
    func makeRequest()throws -> URLRequest{
        let mergedURL = baseURL.appendingPathComponent(endPoint)
        var urlComponents = URLComponents(url: mergedURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItem
        
        guard let finalURL = urlComponents?.url else{throw NetworkServiceError.invalidUrl(url: mergedURL.absoluteString)}
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}



enum EndPoint: EndPointProtocol{
    //https://de1.api.radio-browser.info/json/stations/search?limit=100&language=tamil&hidebroken=true&order=clickcount&reverse=false
    //https://de1.api.radio-browser.info/json/stations/search?name=suryan
    //https://de1.api.radio-browser.info/json/url/c7d2d51a-1d3f-46ed-bde9-e65722470109
    case allStations
    case search(name: String)
    case streamingUrl(stationId: String)
    case stationInfo(stationId: String)
    
    var baseURL: URL {
        switch self {
        case .allStations:
            return URL(string:Constant.BASE_URL)!
        case .search(let name):
            return URL(string:Constant.BASE_URL)!
        case .streamingUrl(let stationId):
            return URL(string:Constant.BASE_URL)!
        case .stationInfo(let stationId):
            return URL(string: Constant.BASE_URL)!
        }
    }
    
    var endPoint: String {
        switch self {
        case .allStations:
            return "stations/search"
        case .search(let name):
            return "stations/search"
        case .streamingUrl(let stationId):
            return "url/\(stationId)"
        case .stationInfo(let stationId):
            return "stations/byuuid/\(stationId)"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .allStations:
            return .GET
        case .search(let name):
            return .GET
        case .streamingUrl(let stationId):
            return .GET
        case .stationInfo(_ ):
            return .GET
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .allStations:
            return ["User-Agent": "TamilInternetRadio/1.0"]
        case .search(let name):
            return ["User-Agent": "TamilInternetRadio/1.0"]
        case .streamingUrl(let stationId):
            return ["User-Agent": "TamilInternetRadio/1.0"]
        case .stationInfo( _):
            return ["User-Agent": "TamilInternetRadio/1.0"]
        }
    }
    
    var queryItem: [URLQueryItem] {
        switch self {
        case .allStations:
            return [
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "language", value: "tamil"),
                URLQueryItem(name: "hidebroken", value: "true"),
                URLQueryItem(name: "order", value: "clickcount"),
                URLQueryItem(name: "reverse", value: "true")
            ]
        case .search(let name):
            return [
                URLQueryItem(name: "name", value: "\(name)")
            ]
        case .streamingUrl(let stationId):
            return []
        case .stationInfo(_ ):
            return []
        }
    }
}


protocol NetworkServiceProtocol{
    func performRequest<T:Decodable,U:Encodable>(endPoint: EndPoint,body: U?)async throws  -> T
}



class NetworkService: NetworkServiceProtocol{
    private let session: URLSession
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func performRequest<T:Decodable,U:Encodable>(endPoint: EndPoint,body: U?)async throws  -> T{
        var request = try endPoint.makeRequest()
        if let body{
            let encodedData = try JSONEncoder().encode(body)
            request.httpBody = encodedData
        }
        let (data,response) = try await self.session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else{throw NetworkServiceError.invalidResponse}
        guard  (200...299).contains(httpResponse.statusCode) else{throw NetworkServiceError.invalidStatus(code: httpResponse.statusCode)}
        
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
}
