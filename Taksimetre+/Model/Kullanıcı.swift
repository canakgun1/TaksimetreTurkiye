//
//  Kullanıcı.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 29.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Kullanıcı: Codable {
 
    var ilkYükleme: String
    var açmaSayısı: Int
    var açmaTarihleri: [String]
    var farklıYereRotalar: [Rota]
    var rotalar: [Rota] {
        didSet {
            guard rotalar.count > 1 else { farklıYereRotalar.append(rotalar[0])
                return
            }
            if rotalar.last != rotalar[rotalar.count - 2] {
                farklıYereRotalar.append(rotalar.last!)
            }
        }
    }
//    Reklamsız : - 14 Mayıs 23 gibi
    var sorulanlar: [String : [String]]
    var model: String
    var ülke: String
    var dil: String
    
    func kaydet(eski: Kullanıcı?) {
       
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: "Kullanıcı")
        } catch {
            print("Kullanıcı kaydedilemedi: \(error.localizedDescription)")
        }
        
        if !(eski?.rotalar.count == self.rotalar.count && eski?.farklıYereRotalar.count != self.farklıYereRotalar.count) || (eski?.açmaSayısı == self.açmaSayısı && eski?.açmaTarihleri != self.açmaTarihleri) {
            interneteKaydet()
        }
        
    }
    
    static func al() -> Kullanıcı {
        
        let decoder = JSONDecoder()
        do {
            let data = UserDefaults.standard.data(forKey: "Kullanıcı") ?? Data()
            let kullanıcı = try decoder.decode(Kullanıcı.self, from: data)
            return kullanıcı
            
        } catch {
            print("Kullanıcı alınamadı: \(error.localizedDescription)")
            return kullanıcı ?? Kullanıcı(ilkYükleme: "", açmaSayısı: 0, açmaTarihleri: [], farklıYereRotalar: [], rotalar: [], sorulanlar: ["Puan":[],"Reklamsız":[]], model: "", ülke: "", dil: "")
        }
        
    }
    
    private func interneteKaydet() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Kullanicilar").document(uid).setData([
            "İlk Yükleme" : ilkYükleme,
            "Açma Sayısı" : açmaSayısı,
            "Açma Tarihleri" : açmaTarihleri,
            "Rota Sayısı" : rotalar.count,
            "Rotalar" : rotalar.map({dict($0)}),
            "Sorulanlar" : sorulanlar,
            "Model" : model,
            "Ülke" : ülke,
            "Dil" : dil,
            "Para Alındı" : paraAlındı
        ])
        
    }
}

var kullanıcı: Kullanıcı? = nil {
    didSet {
        kullanıcı?.kaydet(eski: oldValue)
    }
}
