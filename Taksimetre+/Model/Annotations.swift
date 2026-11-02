//
//  Annotations.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 26.12.2021.
//

import Foundation
import UIKit
import MapKit

extension HaritaVC {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // BackOverlay Ayarla - Renk Değişimi
        if let polyline = overlay as? MKPolyline {
            
            let rend = MKPolylineRenderer(polyline: polyline)
            rend.strokeColor = currentPolyline == polyline ? #colorLiteral(red: 1, green: 0.7843137255, blue: 0.3137254902, alpha: 0.8999943002) : #colorLiteral(red: 0, green: 0.5294117647, blue: 0.9176470588, alpha: 0.7498149246)
            rend.lineWidth = currentPolyline == polyline ? 8 : 10
            rend.lineCap = .round
            rend.lineJoin = .round
            
            return rend
            
        }
        
        return MKOverlayRenderer()
        
    }
    
}
