//
//  AppDelegate.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 20.04.2021.
//

import UIKit
import CoreLocation
import GoogleMobileAds
import FirebaseCore
import StoreKit
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func checkPurchase() async {
        for await result in Transaction.currentEntitlements {
            var productID = ""
            if türk() {
                productID = "TaksimetrePremiumTR"
            } else {
                productID = "TaksimetrePremium"
                
            }
            if case .verified(let transaction) = result,
               transaction.productID == productID,
               transaction.revocationDate == nil {
                await MainActor.run { paraAlındı = true }
                return
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MobileAds.shared.start(completionHandler: nil)
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        SKPaymentQueue.default().add(iapObserver)
        Task { await checkPurchase() }
        if al(forKey: "IAP") == 1 {
            paraAlındı = true
        }
        
        if UserDefaults.standard.integer(forKey: "KullanıcıVar") != 1 {
            
            let yeniKullanıcı = Kullanıcı(ilkYükleme: Date().günAyYıl, açmaSayısı: 1, açmaTarihleri: [Date().günAyYıl], farklıYereRotalar: [], rotalar: [], sorulanlar: ["Puan" : [], "Reklamsız" : []], model: UIDevice.modelName, ülke: NSLocale.current.regionCode ?? "??", dil: NSLocale.current.languageCode ?? "??")
            kullanıcı = yeniKullanıcı
            UserDefaults.standard.set(1, forKey: "KullanıcıVar")
        } else {
            kullanıcı = Kullanıcı.al()
            kullanıcı?.açmaSayısı += 1
            kullanıcı?.açmaTarihleri.append(Date().günAyYıl)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            addFstore()
//        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(iapObserver)
    }


}

