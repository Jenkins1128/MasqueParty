//
//  LocationManager.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/14/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func setControllerTitle(_ title: String)
}

struct LocationManager {
    
    var manager = CLLocationManager()
    var delegate : LocationManagerDelegate?
    
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
    
    
    func searchNearbyForUsers() {
        delegate?.setControllerTitle("Searching nearby...")
        //check if location services is on
        if checkIfLocationEnabled() {
            //get postalCity using CoreLocation
            requestLocation()
        }else{
            //else set nav title to Enable location services...
            delegate?.setControllerTitle("Enable location services...")
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

extension LocationManagerDelegate {
    func setControllerTitle(_ title: String) {}
}
