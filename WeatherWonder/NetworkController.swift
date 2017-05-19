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

    /// Dynamically returns the url for the API call by addin the current zip code.
    /// Only works in USA
    var apiURL: String {
        let location = locationController.currentZipCode
        return "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(location),us&units=imperial&cnt=7&APPID=3e15652a662d33a186fdcf5567cf1f66"
    }
    let networkQueue = OperationQueue()
    let locationController = LocationController()

    /// Fetches the JSON from the API using rhe apiURL property
    ///
    /// - Parameter completionHandler: returns an optional array of forecasts of successful, a optional NetworkControllerError error if unsuccessful
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

    /// Creates the newtork call to the API to fetch the JSON as data
    ///
    /// - Parameters:
    ///   - aURL: the url for the api call
    ///   - completionHandler: returns optional data if successful, an optional NetworkControllerError if unsuccessful
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
                    completionHandler(dataFromRequest, .failedResponse)
                }
            } else {
                completionHandler(nil, .noResponse)
            }
        }).resume()
    }
}
