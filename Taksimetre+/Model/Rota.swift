//
//  Rota.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 29.01.2023.
//

import Foundation

struct Rota: Codable, Equatable {
    
    var tarih: Date
    var başlangıç: String
    var bitiş: String
    var başlangıçŞehri: String
    var bitişŞehri: String
    var koordinatlar: [String : [String : Double]]
    
    static func !=(lhs: Rota, rhs: Rota) -> Bool {
        
        lhs.bitiş != rhs.bitiş
        
    }
}

func dict(_ rota: Rota) -> [String : Any] {
    
    return ["Tarih" : rota.tarih.günAyYılSaatDk, "Başlangıç" : rota.başlangıç, "Bitiş" : rota.bitiş, "Başlangıç Şehri" : rota.başlangıçŞehri, "Bitiş Şehri" : rota.bitişŞehri, "Koordinatlar" : rota.koordinatlar]
    
}
