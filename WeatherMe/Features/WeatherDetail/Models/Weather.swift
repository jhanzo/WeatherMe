//
//  Weather.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 05/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let coord: Coord
    let sys: Sys
    let weather: [WeatherElement]
    let main: Main
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let id: Int
    let dt: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, pressure: Double
    let humidity: Int
    let tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Rain: Codable {
    let the3H: Int

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Sys: Codable {//swiftlint:disable:this type_name
    let country: String
    let sunrise, sunset: Int
}

struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed, deg: Double
}
