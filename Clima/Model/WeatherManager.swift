//
//  WeatherManager.swift
//  Clima
//
//  Created by Ryan Henzell-Hill on 20/06/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=b2b6a6f41588a767da5d255e281f2b67&q="
    
    func fetchWeatherData(for cityName: String) {
        let urlString = weatherURL + cityName
        print(urlString)
        performRequest(to: urlString)
    }
    
    func performRequest(to urlString: String) {
        // 1. Create a URL object
        guard let url = URL(string: urlString) else { return }
        
        // 2. Create a URL session
        let session = URLSession(configuration: .default)
        
        // 3. Give the session a task
        let task = session.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let safeData = data else { return }
            parseJSON(weatherData: safeData)
        }
        
        // 4. Start the task
        task.resume()
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let conditionName = getConditionName(weatherCode: id)
            print(id)
            print(conditionName)
        } catch {
            print(error)
        }
    }
    
    func getConditionName(weatherCode: Int) -> String {
        var conditionName: String
        
        switch weatherCode {
        case 200...232:
            conditionName = "Thunderstorm"
        case 300...321:
            conditionName = "Drizzle"
        case 500...531:
            conditionName = "Rain"
        case 600...622:
            conditionName = "Snow"
        case 701...781:
            conditionName = "Atmosphere"
        case 800:
            conditionName = "Clear"
        case 801...804:
            conditionName = "Clouds"
        default:
            conditionName = "Invalid code"
        }
        
        return conditionName
    }
}
