//
//  Menu.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 26.12.2021.
//

import Foundation
import UIKit
import MapKit

extension HaritaVC {
    
    func showDistance(destination: CLLocation, placemark: MKPlacemark, mapItem: MKMapItem) {
        menu.mapItem = mapItem
        
        menüGösteriliyor = true
        if oldu == false {
            sheetCoordinator.setPosition(parent!.view.frame.height - 323, animated: true)
            oldu = true
        } else {
            
            sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                       delegate: self)
            
            menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu") as! MenuVC
           
            menu.sheetCoordinator = sheetCoordinator
            menu.mapItem = mapItem
            sheetCoordinator.addSheet(menu, to: self, didContainerCreate: { container in
                let f = self.view.frame
                let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
                container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
            })
            
            sheetCoordinator.setCornerRadius(10)
            sheetCoordinator.setPosition(parent!.view.frame.height - 323, animated: true)
        }
            
        guard let userLocation = locationManager.location else {
            menu.distanceLabel.isHidden = true
            return
        }
        menu.distanceLabel.isHidden = false
        
//        let distanceMeters = destination.distance(from: userLocation)
//        
//        if distanceMeters >= 1000 {
//            menu.distanceLabel.text = "\((distanceMeters / 1000).rounded(decimals: 1)) km"
//        } else {
//            switch distanceMeters {
//            case let m where m <= 50:
//                menu.distanceLabel.text = "En fazla 50 m"
//            default:
//                menu.distanceLabel.text = "\(Int((distanceMeters / 10).rounded() * 10)) m"
//            }
//            
//        }
//        menu.distanceLabel.text = menu.distanceLabel.text!.replacingOccurrences(of: ".", with: ",")
        
        
        
    }
    
    @objc func xPressed() {
        navBarAyarla()
        navigationItem.title = "Where will you go?".l
        navigationController?.navigationBar.prefersLargeTitles = true
        routes = []
        currentPolyline = nil
        randoms = [:]
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        updateLocation()
    }
    
    func updateMenu(name: String, destination: CLLocation, placemark: MKPlacemark, mapItem: MKMapItem) {
        
        self.showDistance(destination: destination, placemark: placemark, mapItem: mapItem)
        menu.titleNameLabel.text = name
        
    }
    
}

var menüGösteriliyor: Bool = false
