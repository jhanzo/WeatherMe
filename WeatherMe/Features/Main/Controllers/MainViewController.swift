//
//  MainViewController.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 04/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import UIKit
import CoreLocation

// View Controller for managing route dispatching
// Perfect place for checking whether user is logged or not
class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var bgImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        BackgroundImage.download()

        self.bgImage.image = BackgroundImage.read()

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainToWeatherDetailSegueIdentifier", sender: nil)
        }
    }
}
