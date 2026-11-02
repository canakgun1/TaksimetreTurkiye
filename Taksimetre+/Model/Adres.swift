//
//  Adres.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 30.07.2021.
//
import Foundation
import MapKit

extension MKPlacemark {
    
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    
    /// city, eg. Cupertino
    var city: String? { locality }
    
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    
    /// state, eg. CA
    var state: String? { administrativeArea }
    
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    
    func adres() -> String {
        
        let placemark = self
        let streetName = placemark.streetName != nil ? placemark.streetName! + " " : ""
        let streetNumber = placemark.streetNumber != nil ? placemark.streetNumber! : ""
        let zipCode = placemark.zipCode != nil ? placemark.zipCode! + " " : ""
        let city = placemark.city != nil ? placemark.city! + " " : ""
        let neighborhood = placemark.neighborhood != nil ? placemark.neighborhood! : ""
        let country = placemark.country != nil ? placemark.country! + " " : ""
        if streetName == "" && streetNumber == "" {
            return "\(zipCode)\(city)\(neighborhood)\n\(country)"
        }
        return "\(streetName)\(streetNumber)\n\(zipCode)\(city)\(neighborhood)\n\(country)"
        
    }
    
}

extension MKMapItem {
    
    func menuData() -> [[String]] {
        
        if let phone = phoneNumber {
            
            if let internet = url {
                
                return [["Phone Number", phone], ["Website", internet.absoluteString], ["Address", placemark.adres()]]
                
            } else {
                
                return [["Phone Number", phone], ["Address", placemark.adres()]]
                
            }
            
        } else {
            
            if let internet = url {
                
                return [["Website", internet.absoluteString], ["Address", placemark.adres()]]
                
            } else {
                
                return [["Address", placemark.adres()]]
                
            }
            
        }
        
    }
    
}
