//
//  Ücret.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 12.04.2022.
//

import Foundation
import MapKit
import FirebaseFirestore

struct Tarife {
    
    /// Türk Lirası
    var açılışÜcreti: Double

    /// Kilometre
    var birimMesafe: Double
    
    /// Türk Lirası
    var birimMesafeÜcreti: [String : Double]
    
    /// Dakika
    var birimZaman: Double
    
    /// Türk Lirası
    var birimZamanÜcreti: Double
    
    /// Türk Lirası
    var indiBindi: Double
    
    /// Türk Lirası
    func hesapla(saniye: Double, kilometre: Double) -> Double {
        
        let dk = (saniye / 60).rounded(.up)
        let km = kilometre / 1000
        var hesaplamaBirimMesafeÜcreti = 0.0
        let zamanÜcreti = (dk / birimZaman).rounded(.down) * birimZamanÜcreti
        var kilometreÜcreti: Double = 0.0
        
        if birimMesafeÜcreti.keys.contains("0") {
            
            hesaplamaBirimMesafeÜcreti = birimMesafeÜcreti["0"]!
            
            kilometreÜcreti = (km / birimMesafe).rounded(.down) * hesaplamaBirimMesafeÜcreti
            
        } else {
            
            var dists = birimMesafeÜcreti.keys.map({Int($0)!}).sorted()
            dists.insert(0, at: 0)
            var remKm = km
            
            var counter = 0
            
            while remKm >= Double(dists[counter + 1] - dists[counter]) {
                
                kilometreÜcreti += (Double(dists[counter + 1] - dists[counter])) / birimMesafe * birimMesafeÜcreti["\(dists[counter + 1])"]!
                
                remKm -= Double(dists[counter + 1] - dists[counter])
                
                counter += 1
                
            }
            
            kilometreÜcreti += remKm / birimMesafe * birimMesafeÜcreti["\(dists[counter + 1])"]!
            
        }
        
        let ücret = max(zamanÜcreti, kilometreÜcreti) + açılışÜcreti
        return ücret < indiBindi ? indiBindi : ücret
    }
    
    init(açılışÜcreti: Double, birimMesafe: Double, birimMesafeÜcreti: [String : Double], birimZaman: Double, birimZamanÜcreti: Double, indiBindi: Double) {
        
        self.açılışÜcreti = açılışÜcreti
        self.birimMesafe = birimMesafe
        self.birimMesafeÜcreti = birimMesafeÜcreti
        self.birimZaman = birimZaman
        self.birimZamanÜcreti = birimZamanÜcreti
        self.indiBindi = indiBindi
        
    }
    
    init(data: [String : Any]) {
        
        self.açılışÜcreti = data["Açılış"] as? Double ?? 1
        self.birimMesafe = data["Birim Mesafe"] as? Double ?? 1
        self.birimMesafeÜcreti = data["Birim Mesafe Ücreti"] as? [String : Double] ?? ["0" : 1]
        self.birimZaman = data["Birim Zaman"] as? Double ?? 1
        self.birimZamanÜcreti = data["Birim Zaman Ücreti"] as? Double ?? 1
        self.indiBindi = data["İndi Bindi"] as? Double ?? 1
        
    }
    
}

var tarifeler: [String : Tarife] = [:]
var şehirler: [String : [Double]] = [:]

//func addFstore() {
//
//
//    let coords = ["İzmir" : [38.48374029680161, 27.160846107419573], "İstanbul" : [41.175949400311474, 28.939417514101834], "Ankara" : [40.081361932176776, 32.829968505521705], "Muğla" : [37.221067002209644, 28.360183501228086], "Antalya" : [36.95937527641095, 30.738563951992674]]
////    var tarifeler = [
////        "İstanbul" : Tarife(açılışÜcreti: 9.8, birimMesafe: 0.1, birimMesafeÜcreti: 0.63, birimZaman: 1, birimZamanÜcreti: 1.12, indiBindi: 28),
////        "İzmir" : Tarife(açılışÜcreti: 6, birimMesafe: 0.1, birimMesafeÜcreti: 0.9, birimZaman: 1, birimZamanÜcreti: 0.5, indiBindi: 20),
////        "Ankara" : Tarife(açılışÜcreti: 7.5, birimMesafe: 0.1, birimMesafeÜcreti: 0.6, birimZaman: 1, birimZamanÜcreti: 0.8, indiBindi: 20),
////        "Muğla" : Tarife(açılışÜcreti: 7.12, birimMesafe: 0.1, birimMesafeÜcreti: 1.43, birimZaman: 1, birimZamanÜcreti: 0.75, indiBindi: 30),
////        "Antalya" : Tarife(açılışÜcreti: 10, birimMesafe: 0.1, birimMesafeÜcreti: 1.2, birimZaman: 1, birimZamanÜcreti: 0.5, indiBindi: 25)
////    ]
//
//    for t in tarifeler {
//        Firestore.firestore().collection("Şehirler").document(t.key).setData(["Açılış" : t.value.açılışÜcreti, "Birim Mesafe" : t.value.birimMesafe, "Birim Mesafe Ücreti" : [t.value.birimMesafeÜcreti], "Birim Zaman" : t.value.birimZaman, "Birim Zaman Ücreti" : [t.value.birimZamanÜcreti], "İndi Bindi" : t.value.indiBindi, "C1" : coords[t.key]![0], "C2" : coords[t.key]![1]])
////        Firestore.firestore().collection("Şehirler").document(t.key).setData(["Ad":t.key])
//    }
//
//
//
//}

var şehirError: String? = nil

func şehirleriAl() {
    
    Firestore.firestore().collection("Şehirler").getDocuments { snap, error in
        if let error = error {
            şehirError = error.localizedDescription
            return
        }
        
        guard let snap = snap?.documents else { şehirError = ""; return }
        
        tarifeler = [:]
        şehirler = [:]
        
        for doc in snap {
            
            let data = doc.data()
            
            tarifeler[doc.documentID] = Tarife(data: data)
            
            şehirler[doc.documentID] = [data["C1"] as? Double ?? 1, data["C2"] as? Double ?? 1]
            
            
        }
        
        //let data = snap!.documents
        
    }
    
}


var şehir = "İstanbul"

/// 1-Sarı 2-Mavi 3-Siyah
var taksiTipi = 1


func şehriAyarla(başlangıç: MKMapItem) {
    
    let coordinates = başlangıç.placemark.coordinate

    var enYakın = Float.infinity
    
    for ş in şehirler.filter({($0.key != "İstanbulMavi") && ($0.key != "İstanbulSiyah")}) {
        
        let lat = abs(ş.value[0] - coordinates.latitude)
        let long = abs(ş.value[1] - coordinates.longitude)
        
        let dist = sqrt(pow(lat, 2) + pow(long, 2))
        
        if Float(dist) < enYakın {
            
            şehir = ş.key
            enYakın = Float(dist)
            
        }
        
    }
    
}

extension MKRoute {
    
    var ücret: Double {
        
        if şehir != "İstanbul" {
            
            return tarifeler[şehir]!.hesapla(saniye: expectedTravelTime, kilometre: distance)
            
        }
        
        var şehirTemp = şehir
        
        if taksiTipi == 2 {
            şehirTemp = "İstanbulMavi"
        } else if taksiTipi == 3 {
            şehirTemp = "İstanbulSiyah"
        }
        
        return tarifeler[şehirTemp]!.hesapla(saniye: expectedTravelTime, kilometre: distance)
        
    }
    
}
var rotaÜcreti = 0.0 {
    didSet {
        postN("ÜcretChanged")
    }
}
var rotaKm = 0.0 {
    didSet {
        postN("ÜcretChanged")
    }
}

var rota: MKRoute? = nil

extension MKRoute {
    
    var rotaKöprüÜcretleri: Double {
        
        var price = 0.0
        
        var coords: [CLLocationCoordinate2D] = []
        
        for pointNo in 0..<self.polyline.pointCount {
            
            let coord = self.polyline.points()[pointNo].coordinate
            
            coords.append(coord)
            
        }
        
        for k in köprüler {
            if coords.contains(k.value) {
                price += köprüÜcretleri[k.key]!
            }
        }
        
        return price
    }
    
}
