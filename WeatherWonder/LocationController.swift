//
//  LocationController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 Nate Birkholz. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError {
    case failedLocation
}

class LocationController: NSObject, CLLocationManagerDelegate {

    var currentZipCode: String = "56001"
    var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations[0], completionHandler: {(placemarks, error) -> Void in
            if error != nil { return }

            if placemarks!.count > 0 {
                if let pm = placemarks?[0], let code = pm.postalCode {
                    print(code) //prints zip code
                    self.currentZipCode = code
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    func updadeLocation(completionHandler: @escaping (LocationError?)->()) {
        if let  thisLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(thisLocation, completionHandler: {(places, error) -> Void in
                if error != nil { return }

                if let count = places?.count, count > 0 {
                    if let pm = places?[0], let code = pm.postalCode {
                        print(code) //prints zip code
                        self.currentZipCode = code
                        completionHandler(nil)
                    }
                } else {
                    print("Problem with the data received from geocoder")
                    completionHandler(.failedLocation)
                }
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
