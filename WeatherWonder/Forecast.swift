//
//  Forecast.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import Foundation

class Forecast {

  var forecastDay : String
  var forecastType : String
  var forecastHumidity : Int
  var forecastMaxTemp : Int
  var forecastMinTemp : Int

  init (day: String, weatherID: String, humidity: Int, maxTemp: Int, minTemp: Int) {
    self.forecastDay = day
    self.forecastType = weatherID
    self.forecastHumidity = Int(humidity)
    self.forecastMaxTemp = maxTemp
    self.forecastMinTemp = minTemp
  }





} // End
