//
//  SettingsVC.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 28.08.2022.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController {
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var haritaVC: HaritaVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restoreButton.setTitle("Restore Purchases".l, for: .normal)
        purchaseButton.setTitle("Get Lifetime Access".l, for: .normal)
        if paraAlındı {
            purchaseButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func restoreClicked(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func purchaseClicked(_ sender: UIButton) {
        haritaVC.IAPSor()
    }
}
