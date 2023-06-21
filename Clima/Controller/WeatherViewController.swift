//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cityQuery = searchTextField.text else { return }
        weatherManager.fetchWeatherData(for: cityQuery)
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather.tempString)
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName : weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

