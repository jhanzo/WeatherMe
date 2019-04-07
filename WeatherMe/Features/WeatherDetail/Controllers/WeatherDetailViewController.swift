//
//  WeatherDetailViewController.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 05/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie
import MapKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var iconView: UIView!

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cloudiness: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var lastUpdate: UILabel!

    lazy var locationManager: CLLocationManager = {
       return CLLocationManager()
    }()
    // current location
    var location: CLLocation? {
        didSet {
            guard let _location = self.location else {
                return
            }
            self.getWeather(from: _location)
        }
    }

    var weather: WeatherDTO?
    var weatherLogo: AnimationView = AnimationView(name: "loader")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.weatherLogo.center.x = self.iconView.center.x
        self.weatherLogo.loopMode = .loop
        self.iconView.addSubview(self.weatherLogo)
        self.weatherLogo.play()

        self.bgImage.image = BackgroundImage.read().applyDarkBlur()

        DispatchQueue.main.async {
            if
                CLLocationManager.locationServicesEnabled(),
                [.authorizedWhenInUse, .authorizedAlways].contains(CLLocationManager.authorizationStatus())
            {
                self.location = self.locationManager.location
            } else {
                self.weatherLogo.stop()
            }
        }
    }

    private func setInfo() {
        guard let _weather = self.weather else {
            return
        }
        DispatchQueue.main.async {
            self.temperature.text = _weather.temperature
            self.cloudiness.text = _weather.cloudiness
            self.windSpeed.text = _weather.windSpeed
            self.humidity.text = _weather.humidity
            self.range.text = _weather.temperatureRange
            self.weatherLogo.animation = Animation.named(_weather.lottieIcon.rawValue)
            self.weatherLogo.play()
            self.weather?.datetime { date, sunrise, sunset in
                self.cityName.text = "\(_weather.cityName) - \(date)"
                self.sunrise.text = sunrise
                self.sunset.text = sunset
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                self.lastUpdate.text = "Last update: \(dateFormatter.string(from: Date()))"
            }
            self.bottomInfoView.isHidden = false
        }
    }

    @IBAction func locateAction(_ sender: Any) {
        if
            !CLLocationManager.locationServicesEnabled() ||
            ![.authorizedWhenInUse, .authorizedAlways].contains(CLLocationManager.authorizationStatus())
        {
            self.displayEnableLocation()
            return
        }

        self.location = self.locationManager.location
    }

    @IBAction func syncAction(_ sender: Any) {
        guard let _location = self.location else {
            return
        }
        self.getWeather(from: _location)
    }

    private func getWeather(from location: CLLocation) {
        let getWeatherDetail: (Weather) -> Void = { weather in
            self.weather = WeatherDTO(weather: weather)
            self.setInfo()
        }
        HTTPEndpoint.weather(location).request(completion: getWeatherDetail)
    }

    private func displayEnableLocation() {
        let alert = UIAlertController(
            title: "Location Authorization",
            message: "Location services are disabled, please enable them in options",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Go to settings...", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    private func displayNoAddressFound(cityName: String) {
        let alert = UIAlertController(
            title: "No address found",
            message: "\(cityName) not found",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension WeatherDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let _text = textField.text else {
            return true
        }

        let geocode = CLGeocoder()
        geocode.geocodeAddressString(_text) { placemark, error in
            guard let _location = placemark?.first?.location, error == nil else {
                print("City cannot be found : \(error!.localizedDescription)")
                self.displayNoAddressFound(cityName: _text)
                return
            }
            self.location = _location
            self.locationButton.isEnabled = false
        }
        return true
    }
}
