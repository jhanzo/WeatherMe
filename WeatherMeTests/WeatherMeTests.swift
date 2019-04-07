//
//  WeatherMeTests.swift
//  WeatherMeTests
//
//  Created by Jessy Hanzo on 04/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import XCTest
@testable import WeatherMe

class WeatherMeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleWeather() {
        let url = Bundle(for: type(of: self)).url(forResource: "weather", withExtension: "json")!
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        let weatherJson = try! JSONDecoder().decode(Weather.self, from: data)
        let weatherDTO = WeatherDTO(weather: weatherJson)

        // test non localized
        assert(weatherDTO.cityName == "Brest")
        assert(weatherDTO.temperature == "7°C")
        assert(weatherDTO.cloudiness == "0%")
        assert(weatherDTO.windSpeed == "2.1 m/s")
        assert(weatherDTO.humidity == "93%")
        assert(weatherDTO.temperatureRange == "5°C...10°C")
        assert(weatherDTO.humidity == "93%")
        assert(weatherDTO.pressure == "1008 hPa")
    }
}
