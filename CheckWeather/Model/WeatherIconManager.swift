//
//  WeatherIconManager.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 29.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import UIKit

enum WeetherIconManager: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloud-night"
    
    case unpredictedIcon = "unpredicted-icon"
    
    init(rawValue: String) {
        switch rawValue {
        case "clear-day": self = .clearDay
        case "clear-night": self = .clearNight
        case "rain": self = .rain
        case "snow": self = .snow
        case "sleet": self = .sleet
        case "wind": self = .wind
        case "fog": self = .fog
        case "cloudy": self = .cloudy
        case "partly-cloudy-day": self = .partlyCloudyDay
        case "partly-cloud-night": self = .partlyCloudyNight
    
        default:
            self = .unpredictedIcon
        }
    }
}

extension WeetherIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue) ?? #imageLiteral(resourceName: "cloudly")
    }
}
