//
//  Weather.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 29.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherResponse: Decodable {
    let currently: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: String
    
}

extension CurrentWeather {
    
    var iconImage: UIImage {
        return WeetherIconManager(rawValue: icon).image
    }
    
    var pressureString: String {
        return "\(Int(pressure)) mm"
    }
    var humidityString: String {
        return "\(Int(humidity * 100))%"
    }
    var temperatureString: String {
        return "\(Int(temperature))˚C"
    }
    var apparentTemperatureString: String {
        return "Feels like \(Int(apparentTemperature))˚C"
    }
    
}
