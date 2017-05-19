//
//  NetworkController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import Foundation
import CoreLocation

enum NetworkControllerError {
    case noData
    case noResponse
    case failedResponse
    case unknownError
    case parseError
}

class NetworkController {
    var apiURL: String {
        let location = locationController.currentZipCode
        print("http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(location),us&units=imperial&cnt=7&APPID=3e15652a662d33a186fdcf5567cf1f66")
        return "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(location),us&units=imperial&cnt=7&APPID=3e15652a662d33a186fdcf5567cf1f66"
    }
    let networkQueue = OperationQueue()
    let locationController = LocationController()

    init() {
    }

    func getJSONForForecasts(_ completionHandler : @escaping (_ forecasts: [Forecast]?, _ error: NetworkControllerError?) -> ()) {
        self.fetchJSONFromURL(self.apiURL, completionHandler: { (maybeDataFromURL, maybeError) -> () in
            guard let dataResult = maybeDataFromURL else {
                if let error = maybeError {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, .unknownError)
                }

                return
            }

            do {
                let parser = JsonParser()
                let forecasts = try parser.parseJSONIntoForecasts(dataResult)
                OperationQueue.main.addOperation({ () -> Void in
                    completionHandler(forecasts, nil)
                })
            } catch {
                completionHandler(nil, .parseError)
            }
        })
    }

    func fetchJSONFromURL(_ aURL: String, completionHandler : @escaping (_ dataFromURL: Data?, _ error: NetworkControllerError?) -> ()) {
        let fetchURL = URL(string: aURL)
        let fetchSession = URLSession.shared
        var request = URLRequest(url: fetchURL!)
        request.httpMethod = "GET"

        fetchSession.dataTask(with: request, completionHandler: { (maybeData, response, error) -> Void in
            guard let dataFromRequest = maybeData else {
                completionHandler(nil, .noData)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    completionHandler(dataFromRequest, nil)
                default:
                    print("ERROR: Bad response")
                    completionHandler(dataFromRequest, .failedResponse)
                }
            } else {
                print("NO RESPONSE------")
                completionHandler(nil, .noResponse)
            }
        }).resume()
    }
    
} // End
