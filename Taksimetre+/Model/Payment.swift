//
//  Payment.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 22.08.2022.
//

import Foundation
import StoreKit
import MapKit
import FirebaseFirestore

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    override init() {
        super.init()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            // Do not block the UI. Allow the user to continue using the app.
            case .deferred:
                print("Deferred")
            // The purchase was successful.
            case .purchased:
                yaz(1, forKey: "IAP")
                let isim = türk() ? "TürkAldı" : "YabancıAldı"
                Firestore.firestore().collection("Kullanim").document("*IAP").updateData([isim : FieldValue.increment(Int64(1))])
                paraAlındı = true
                print("Purchased")
                postN("ParaAlındı")
            // The transaction failed.
            case .failed:
                print("Faied")
                postN("ParaAlındı")
            // There're restored products.
            case .restored:
                yaz(1, forKey: "IAP")
                paraAlındı = true
                print("Restored")
                postN("ParaAlındı")
            default:
                print("Default")
                postN("ParaAlındı")
                }
            }
    }
    
}
extension SKProductsRequestDelegate {
    
    func IAPSor() {
        
        print("Para alındı \(paraAlındı)")
        guard !paraAlındı else {return}
        
        if SKPaymentQueue.canMakePayments() {
            
            var productId = ""
            var isim = ""
            
            if türk() {
                
                productId = "TaksimetrePremiumTR"
                
                
            } else {
                productId = "TaksimetrePremium"
                
            }
            
            
            
            let productIdentifiers: Set = [productId]
               
               // Initialize the product request with the above identifiers.
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productRequest.delegate = self
               
               // Send the request to the App Store.
            productRequest.start()
        }
        
    }
}

extension HaritaVC {
    
    func paraAlertGöster(_ suggestion: MKLocalSearchCompletion) {
        
        
        var isim = ""
        if türk() {
            isim = "TürkeSoruldu"
            
            let actions: [UIAlertAction] =
            [
                UIAlertAction(title: "Daha Sonra", style: .cancel, handler: {_ in self.tableViewSelectCompletion(suggestion)}),
                UIAlertAction(title: "Evet", style: .default, handler: {_ in
                    self.IAP()
                    kullanıcı?.sorulanlar["Reklamsız"]?.append(Date().günAyYılSaatDk)
                })
            ]
            
            
            
            alert(başlık: "Reklamları Kaldır", mesaj: "₺49.99 karşılığında reklamsız versiyonu satın almak ister misiniz?", actions: actions)
            
        } else {
            isim = "YabancıyaSoruldu"
            let actions: [UIAlertAction] =
            [
                UIAlertAction(title: "Later", style: .cancel, handler: {_ in self.tableViewSelectCompletion(suggestion)}),
                UIAlertAction(title: "Yes", style: .default, handler: {_ in
                    self.IAP()
                    kullanıcı?.sorulanlar["Reklamsız"]?.append(Date().günAyYılSaatDk)
                })
            ]
            
            
            alert(başlık: "Remove All Ads", mesaj: "Would you like to remove all ads for $2.99?", actions: actions)
            
            
            
        }
        
        Firestore.firestore().collection("Kullanim").document("*IAP").updateData([isim : FieldValue.increment(Int64(1))])
        
    }
    
}


var paraAlındı = false
let iapObserver = StoreObserver()
