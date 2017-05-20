//
//  Forecast.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import Foundation

enum ForecastType: String {
    case sunny = "sunny"
    case cloudy = "cloudy"
    case rainy = "rainy"
}

class Forecast {

  var forecastDay : String
  var forecastType : ForecastType
  var forecastHumidity : Int
  var forecastMaxTemp : Int
  var forecastMinTemp : Int

  init (day: String, forecastType: ForecastType, humidity: Int, maxTemp: Int, minTemp: Int) {
    self.forecastDay = day
    self.forecastType = forecastType
    self.forecastHumidity = Int(humidity)
    self.forecastMaxTemp = maxTemp
    self.forecastMinTemp = minTemp
  }





} // End
