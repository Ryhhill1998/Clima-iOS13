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
    }
}
