//
//  APIWeatherManager.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 30.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longtitude: Double
}

///Сборщик URL запроса
enum ForecastType: FinalURLProtocol {
    case current(coordinates: Coordinates)
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
    
    var apiKey: String {
        return "2a6d8e376a69c1ae07d4a52dd0c2dfdc"
    }
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    var requiredPath: String {
        return "/forecast/\(apiKey)/"
    }
    var path: String {
        switch self {
        case .current(let coordinates):
            let coordinatesPath = "\(coordinates.latitude),\(coordinates.longtitude)"
            let optionalCurrentWeatherParametrs = "?exclude=minutely,hourly,daily,alerts,flags&units=auto"
            return requiredPath + coordinatesPath + optionalCurrentWeatherParametrs
        }
    }
        
}

final class APIWeatherManager: APIManager {
    
    // MARK: - Public Properties
    
    var sessionConfiguration: URLSessionConfiguration
       
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    // MARK: - Init
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    ///менеджер с дефолтным URLSessionConfig
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    // MARK: - Public methods
    
    func fetchCurrentWeatherWith(coordinates: Coordinates,
                                 completionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.current(coordinates: coordinates).request
        fetch(request: request,
              parse: { (data) -> CurrentWeather? in
                return try? JSONDecoder().decode(CurrentWeatherResponse.self,
                                                 from: data).currently
        },
              completionHandler: completionHandler)
    }
   
    
}
