//
//  ViewController.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 29.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

let key = "2a6d8e376a69c1ae07d4a52dd0c2dfdc"

class ViewController: UIViewController {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    
    // MARK: - Public Properties
    
    lazy var weatherManager = APIWeatherManager()
    let coordinates = Coordinates(latitude: 52.929261, longtitude: 36.044182)
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.updateUIWith(currentWeather: weather)
                case .failure(let error):
                    self.alertError(title: "Unable to get data", error: error)
                    print(error)
                }
            }
        }
        
    
    }

    
    // MARK: - IBAction
    
    @IBAction func refresh(_ sender: UIButton) {
        
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func updateUIWith(currentWeather: Weather) {
        
        self.imageView.image = currentWeather.icon
        
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.apparentTemperatureString
        
        
    }
    
    private func alertError(title: String, error: Error) {
        let alertController = UIAlertController(title: title, message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Navigation



}

