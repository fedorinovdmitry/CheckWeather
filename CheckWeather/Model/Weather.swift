//
//  Weather.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 29.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import UIKit

struct Weather {
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: UIImage
    
}

extension Weather: JSONDecodable {
    init?(json: JSON) {
        guard let temperature = json["temperature"] as? Double,
            let apparentTemperature = json["apparentTemperature"] as? Double,
            let humidity = json["humidity"] as? Double,
            let pressure = json["pressure"] as? Double,
            let iconString = json["icon"] as? String
            else { return nil }
        self.temperature = (temperature - 32) / 1.8
        self.apparentTemperature = (apparentTemperature - 32) / 1.8
        self.humidity = humidity
        self.pressure = pressure
        self.icon = UIImage(named: iconString) ?? #imageLiteral(resourceName: "cloudy")
    }
}

extension Weather {
    
    var pressureString: String {
        return "\(Int(pressure)) mm"
    }
    var humidityString: String {
        return "\(Int(humidity))%"
    }
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
    var apparentTemperatureString: String {
        return "Feels like \(Int(apparentTemperature))˚C"
    }
    
}
