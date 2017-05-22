//
//  Forecast.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import Foundation

enum ForecastType: String, CustomStringConvertible {
    case sunny = "sunny"
    case cloudy = "cloudy"
    case rainy = "rainy"

    var description: String {
        return rawValue
    }
}

class Forecast {

    var forecastDay: String
    var forecastType: ForecastType
    var forecastHumidity: Int
    var forecastMaxTemp: Int
    var forecastMinTemp: Int

    init(day: String, typeOfForecast: ForecastType, humidity: Int, maxTemp: Int, minTemp: Int) {
        forecastDay = day
        forecastType = typeOfForecast
        forecastHumidity = Int(humidity)
        forecastMaxTemp = maxTemp
        forecastMinTemp = minTemp
    }
}

extension Forecast: CustomStringConvertible {
    var description: String {
        return "Forecast -- day: \(forecastDay), type: \(forecastType), humidity: \(forecastHumidity), maxTemp: \(forecastMaxTemp), minTemp: \(forecastMinTemp)"
    }
}
