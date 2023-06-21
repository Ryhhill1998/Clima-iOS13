//
//  WeatherManager.swift
//  Clima
//
//  Created by Ryan Henzell-Hill on 20/06/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=b2b6a6f41588a767da5d255e281f2b67&q="
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(for cityName: String) {
        let urlString = weatherURL + cityName
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL object
        guard let url = URL(string: urlString) else { return }
        
        // 2. Create a URL session
        let session = URLSession(configuration: .default)
        
        // 3. Give the session a task
        let task = session.dataTask(with: url) {(data, response, error) in
            if error != nil {
                delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let safeData = data else { return }
            guard let weather = parseJSON(for: safeData) else { return }
            delegate?.didUpdateWeather(self, weather: weather)
        }
        
        // 4. Start the task
        task.resume()
    }
    
    func parseJSON(for weatherData: Data) -> WeatherModel? {
        var weather: WeatherModel?
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            weather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return weather
    }
}
