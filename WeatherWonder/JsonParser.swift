//
//  JsonParser.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case unableToParse
}

class JsonParser {

    func parseJSONIntoForecasts(_ rawJSONData: Data) throws -> [Forecast] {

        do {
            if let dictionaryFromJSON = try JSONSerialization.jsonObject(with: rawJSONData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                var arrayOfForecasts = [Forecast]()

                if let arrayFromJSON = dictionaryFromJSON["list"] as? [Any] {
                    for JSONDictionary in arrayFromJSON {
                        // long let block, if first two succeed this should all succeed
                        if let forecastDictionary = JSONDictionary as? [String: Any],
                            let weatherArray = forecastDictionary["weather"] as? [Any],
                            let weatherDictionary = weatherArray.first as? [String: Any],
                            let tempDictionary = forecastDictionary["temp"] as? [String: Any],
                            let forecastDateCode = forecastDictionary["dt"] as? Double,
                            let forecastIDCode = weatherDictionary["id"] as? Int,
                            let forecastHumidity = forecastDictionary["humidity"] as? Int,
                            let forecastMax = tempDictionary["max"] as? Int,
                            let forecastMin = tempDictionary["min"] as? Int {
                                let id = self.parseWeatherTypeIntoForecastType(forecastIDCode)
                                let day = self.parseDateCodeIntoDay(forecastDateCode)
                                let newForecast = Forecast(day: day, weatherID: id, humidity: forecastHumidity, maxTemp: forecastMax, minTemp: forecastMin)
                                arrayOfForecasts.append(newForecast)
                        } else {
                            throw ParseError.unableToParse
                        }
                    }

                    return arrayOfForecasts

                } else {
                    throw ParseError.unableToParse
                }
            } else {
                throw ParseError.unableToParse
            }
        } catch {
            throw ParseError.unableToParse
        }
    }

    func parseDateCodeIntoDay(_ dateCode: Double) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let aDate = Date(timeIntervalSince1970: TimeInterval(dateCode))
        let dateForForecast = formatter.string(from: aDate)
        return dateForForecast
    }

    func parseWeatherTypeIntoForecastType(_ forecastIDCode: Int) -> String {
        switch forecastIDCode {
        case 200...622, 771, 781, 900...902, 905, 906:
            return "rainy"
        case 700...762, 802...804:
            return "cloudy"
        case 800...801:
            return "sunny"
        default:
            return "sunny"
        }
    }
    
} // End
