//
//  LocationController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 Nate Birkholz. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {

    var currentZipCode: String = "92102"
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
        CLGeocoder().reverseGeocodeLocation(locations[0], completionHandler: {(places, error) -> Void in
            if error != nil { return }

            if let count = places?.count, count > 0 {
                if let place = places?[0], let code = place.postalCode {
                    print(code)
                    self.currentZipCode = code
                }
            } else {
                print("Problem with the data received from CLGeocoder")
            }
        })
    }

    /// Updates the currentZipCode by explicit call instead of in locationManager: didUpdateLocations:
    ///
    /// - Parameter completionHandler: callback upon completion
    func updadeLocation(completionHandler: @escaping ()->()) {
        if let  thisLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(thisLocation, completionHandler: {(places, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler()
                    return
                }

                if let count = places?.count, count > 0 {
                    if let place = places?[0], let code = place.postalCode {
                        print(code)
                        self.currentZipCode = code
                        completionHandler()
                    }
                } else {
                    print("Problem with the data received from CLGeocoder")
                    completionHandler()
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
