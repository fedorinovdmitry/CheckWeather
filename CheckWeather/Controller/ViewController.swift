//
//  ViewController.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 29.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Public Properties
    
    lazy var weatherManager = APIWeatherManager()
    let coordinates = Coordinates(latitude: 59.929261, longtitude: -36.044182)
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getCurrentWeatherData()
        
    
    }

    
    // MARK: - IBAction
    
    @IBAction func refresh(_ sender: UIButton) {
        
        getCurrentWeatherData()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func getCurrentWeatherData() {
        toggleActivityIndicator(on: true)
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
                self.toggleActivityIndicator(on: false)
            }
        }
        
    }
    
    private func updateUIWith(currentWeather: CurrentWeather) {
        
        self.imageView.image = currentWeather.iconImage
        
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

