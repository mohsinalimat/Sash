//
//  LocationManager.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/27/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import CoreLocation


/*
 Dependencies:
    - Preferences Controller
 
 Subscribes to:
    - None
 
 Sends:
    - Location Controller Did Begin Fetching Location
    - Locatiion Controller did Faild Fetching Location
    - Location Controller Did Finish Fetching Location
 
*/
class PTLocationController: NSObject, Controller, CLLocationManagerDelegate {
    
    static var shared = PTLocationController()
    
    var locationManager = CLLocationManager()
    
    /* whether we are in the proccess of fetching location coordinates.. */
    fileprivate(set) var isGettingCoordinates: Bool = false
    
    /* just after getting the coordinates, fetch request will be done to get the placemark for the coordinates */
    fileprivate(set) var isGettingPlacemark: Bool = false
    
    override init(){
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation(){
        NotificationCenter.default.post(name: Notifications.locationControllerDidBeginFetchingLocation, object: self)
        locationManager.requestLocation()
    }
    
    func isPermessionRequested() -> Bool {
        return CLLocationManager.authorizationStatus() != .notDetermined
    }
    
    func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() != .denied
    }
    
    /* fetch the current location at the application launch */
    func startControllingTheWorld() {
        if isPermessionRequested() && isAuthorized() {
            startUpdatingLocation()
        }
    }
}

extension PTLocationController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: Notifications.locationControllerDidChangeAuthorizationStatus, object: self)
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isGettingCoordinates = false
        guard let lastLocation = locations.last else {
            _reportFaildLocationUpdate()
            return
        }
        
        let coordinates = lastLocation.coordinate
        PTPreferencesController.shared.set(coordinates: PTCoordinates(longitude: coordinates.longitude, latitude: coordinates.latitude))
        
        let geocoder = CLGeocoder()
        isGettingPlacemark = true
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            self.isGettingPlacemark = false
            if let _ = error {
                return
            }
            
            guard let firstPlacemark = placemarks?.first else {
                return
            }
            
            PTPreferencesController.shared.set(locationName: firstPlacemark.locality)
        }
        
        NotificationCenter.default.post(name: Notifications.locationControllerDidFinishFetchingLocation, object: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _reportFaildLocationUpdate()
    }
    
    private func _reportFaildLocationUpdate(){
        if PTPreferencesController.shared.isTestingLocation {
            PTPreferencesController.shared.set(coordinates: PTCoordinates(longitude: 31.9454, latitude: 35.9284))
            PTPreferencesController.shared.set(locationName: "Amman")
            NotificationCenter.default.post(name: Notifications.locationControllerDidFinishFetchingLocation, object: self)
            return
        }
        
        NotificationCenter.default.post(name: Notifications.locationControllerDidFaildFetchingLocation, object: self)
    }
}
