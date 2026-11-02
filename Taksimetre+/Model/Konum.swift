//
//  Konum.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 22.01.2022.
//

import Foundation
import MapKit
import CoreLocation

extension HaritaVC {
    
    func updateLocation() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
            }
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                if let loc = locationManager.location {
                    
                    if sonBaşlangıç == nil {
                        mapView.setCenter(loc.coordinate, animated: true)
                        mapView.setRegion(MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 300, longitudinalMeters: 300), animated: true)
                    }
                    
                    
                }
                
            }
            
        }
    }
    
}
