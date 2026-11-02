//
//  Search.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 26.12.2021.
//

import Foundation
import UIKit

extension HaritaVC {
    
    @objc func dismissSearch(notification: NSNotification) {
        search.isActive = false
        search.searchBar.text = "\(notification.userInfo!["Yer"]!)"
    }
    
    @objc func cancelPressed() {
        
        if !(navigationController?.navigationBar.prefersLargeTitles)! {
            self.navigationItem.searchController = nil
        }
        
    }
    
    @IBAction func searchItemTapped(_ sender: UIBarButtonItem) {
        
        self.navigationItem.searchController = self.search
        
        if #available(iOS 13.0, *) {
            var hepsiniBitir = false
            for count in 1...10 {
                search.searchBar.searchTextField.becomeFirstResponder()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(count)) {
                    if self.search.searchBar.searchTextField.isFirstResponder {
                        hepsiniBitir = true
                        return
                    }
                    if hepsiniBitir {
                        return
                    }
                    self.search.searchBar.searchTextField.becomeFirstResponder()
                    
                }
                
            }
            
        }
        
    }
}
