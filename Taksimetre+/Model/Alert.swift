//
//  Alert.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 4.05.2021.
//

import UIKit

extension UIViewController {
    
    func alert(başlık: String, mesaj: String) {
        
        let controller = UIAlertController(title: başlık, message: mesaj, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
        
    }
    
    func alert(başlık: String, mesaj: String, actions: [UIAlertAction]) {
        
        let controller = UIAlertController(title: başlık, message: mesaj, preferredStyle: .alert)
        for action in actions {
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)
        
    }
    
}
