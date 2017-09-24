//
//  CustomLocationManager.swift
//  WeatherVoronezh
//
//  Created by Михаил Нечаев on 23.09.17.
//  Copyright © 2017 Михаил Нечаев. All rights reserved.
//

import Foundation
import CoreLocation

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var city = "Voronezh"
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                self.city = pm.locality!
            }
        })
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription) can't get location")
    }
}
