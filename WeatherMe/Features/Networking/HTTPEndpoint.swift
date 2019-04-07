//
//  HTTPEndpoint.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 05/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import Foundation
import CoreLocation

enum HTTPEndpoint {
    case weather(CLLocation)
    case background

    private static let weatherBaseURL: URL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private static let weatherToken: String = "c3d25de6aa2d5fa2c7fa3232cb8a7429"

    private static let backgroundBaseURL: URL = URL(string: "https://api.unsplash.com")!
    private static let backgroundToken: String = "b6358e72c7b17f9a1c8d32092b1164b6b9662de0c6b21ea29ead9249352b285f"

    /// http base url
    private var baseURL: URL {
        switch self {
        case .background: return HTTPEndpoint.backgroundBaseURL
        case .weather: return HTTPEndpoint.weatherBaseURL
        }
    }

    /// http path for cases
    private var path: String {
        switch self {
        case .weather: return "weather"
        case .background: return "photos/random"
        }
    }

    /// http parameters for cases
    private var parameters: [String: Any] {
        switch self {
        case .weather(let location):
            return [
                "lon" : location.coordinate.longitude,
                "lat" : location.coordinate.latitude,
                "APPID": HTTPEndpoint.weatherToken,
                "units": "metric"
            ]
        case .background:
            return [
                "query" : "landscape",
                "client_id": HTTPEndpoint.backgroundToken
            ]
        }
    }

    /// generate url based on endpoint info
    private var url: URL {
        var url = self.baseURL
        url.appendPathComponent(path)
        var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComp?.queryItems = self.parameters.map { URLQueryItem(name: "\($0.key)", value: "\($0.value)") }
        return urlComp?.url ?? url
    }

    /// Request available API endpoints
    /// - parameters: [String: String], parameters dict to parse into url
    /// - completion: (T) -> (), complete with http request parse object
    func request<T: Decodable>(completion: @escaping (T) -> Void) {
        print("Requesting url : \(self.url.absoluteString)")
        let task = URLSession.shared.dataTask(with: self.url) { data, _, error in
            guard error == nil, let _data = data else {
                print("Artist request API error : \(error!.localizedDescription)")
                return
            }
            do {
                let parseResponse = try JSONDecoder().decode(T.self, from: _data)
                completion(parseResponse)
            } catch {
                print("Cannot parse request API into a Swift object)")
                debugPrint(error)
                return
            }
        }
        task.resume()
    }
}
