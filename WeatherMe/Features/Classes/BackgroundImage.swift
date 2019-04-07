//
//  BackgroundImage.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 07/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import UIKit

struct RemoteImage: Codable {
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case urls
    }
}

struct Urls: Codable {
    let full: String
}

class BackgroundImage {

    static func download() {
        let getBackgroundImage: (RemoteImage) -> Void = { image in
            do {
                let url = URL(string: image.urls.full)!
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)!
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("background.png")
                try image.pngData()?.write(to: fileURL, options: .atomic)
            } catch {
                print("Error while downloading image: \(error.localizedDescription)")
            }
        }
        HTTPEndpoint.background.request(completion: getBackgroundImage)
    }

    static func read() -> UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("background.png").path
        return UIImage(contentsOfFile: filePath) ?? #imageLiteral(resourceName: "default-1")
    }
}
