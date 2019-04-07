//
//  WeatherDTO.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 05/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherDTO {
    let id: Int
    let cityName: String
    let cloudiness: String
    let temperature: String
    let temperatureRange: String
    let humidity: String
    let pressure: String
    let windSpeed: String

    private let sunsetDate: Date
    private let sunriseDate: Date
    private let date: Date
    private let location: CLLocation
    private let icon: String
    private var timezone: TimeZone?

    /// calculate timezone from location
    /// completion: (String, String, String) -> (), return current date, sunrise date, sunset date
    func datetime(completion: @escaping (String, String, String) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self.location) { placemark, error in
            guard let _placemark = placemark?.first, error == nil else {
                print("Cannot find placemark at location \(self.location) : \(error!.localizedDescription)")
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = _placemark.timeZone
            completion(
                dateFormatter.string(from: self.date),
                dateFormatter.string(from: self.sunriseDate),
                dateFormatter.string(from: self.sunsetDate)
            )
        }
    }

    var isNight: Bool {
        return self.date < sunriseDate || self.date > sunsetDate
    }

    var lottieIcon: LottieIcon {
        let code = self.icon
        // get lottie icon if exists else get icon from first 2 char code
        return LottieIcon(rawValue: code) ?? LottieIcon(rawValue: String(code.prefix(2))) ?? .error
    }

    // parameters format
    // https://openweathermap.org/weather-data
    init(weather: Weather) {
        self.id = weather.id
        self.cityName = weather.name
        self.cloudiness = "\(weather.clouds?.all ?? 0)%"
        self.temperature = "\(Int(weather.main.temp))°C"
        self.temperatureRange = "\(Int(weather.main.tempMin))°C...\(Int(weather.main.tempMax))°C"
        self.humidity = "\(weather.main.humidity)%"
        self.pressure = "\(Int(weather.main.pressure)) hPa"
        let speed = weather.wind?.speed ?? 0.0
        self.windSpeed = "\(speed) m/s"
        self.icon = weather.weather.first?.icon ?? "00"
        self.location = CLLocation(latitude: weather.coord.lat, longitude: weather.coord.lon)
        // date management
        self.sunriseDate = Date(timeIntervalSince1970: TimeInterval(exactly: weather.sys.sunrise)!)
        self.sunsetDate = Date(timeIntervalSince1970: TimeInterval(exactly: weather.sys.sunset)!)
        self.date = Date(timeIntervalSince1970: TimeInterval(exactly: weather.dt)!)
    }
}
