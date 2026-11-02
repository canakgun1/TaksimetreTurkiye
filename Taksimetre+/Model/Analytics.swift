//
//  Analytics.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 28.08.2022.
//

import FirebaseFirestore
import MapKit

func kullanimYaz(from başlangıç: MKMapItem?, to destination: MKMapItem?) {
    
    let ş1 = yakınŞehirBul(başlangıç)
    let ş2 = yakınŞehirBul(destination)
    
    let ülke = (NSLocale.current.languageCode ?? "") + " - " + (NSLocale.current.regionCode ?? "")
    let türk = türk() ? "Türk" : "Yabancı"
    
    Firestore.firestore().collection("Kullanim").document("\(ş1) - \(ş2)").updateData(
        [
            türk : FieldValue.increment(Int64(1)),
            ülke : FieldValue.increment(Int64(1))
        ])
    
}

func yakınŞehirBul(_ şehir: MKMapItem?) -> String {
    
    if şehir == nil {
        return "Bilinmiyor"
    }
    
    var tempŞehir = ""
    
    let coordinates = şehir!.placemark.coordinate

    var enYakın = Float.infinity
    
    for ş in şehirler.filter({($0.key != "İstanbulMavi") && ($0.key != "İstanbulSiyah")}) {
        
        let lat = abs(ş.value[0] - coordinates.latitude)
        let long = abs(ş.value[1] - coordinates.longitude)
        
        let dist = sqrt(pow(lat, 2) + pow(long, 2))
        
        if Float(dist) < enYakın {
            
            tempŞehir = ş.key
            enYakın = Float(dist)
            
        }
        
    }
    
    return tempŞehir
    
}

