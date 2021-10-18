//
//  LocationManager.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/14/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationManager {
    
    var manager = CLLocationManager()
    
    func checkIfLocationEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
}
