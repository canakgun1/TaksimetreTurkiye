//
//  Bars.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 24.05.2021.
//

import Foundation
import UIKit

extension HaritaVC {
    
    func navBarAyarla() {
        
        let bar = navigationController?.navigationBar
        
        tableViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YerTVC") as! YerBulTVC)
        tableViewController.tableView.delegate = self
        
        search = UISearchController(searchResultsController: tableViewController)
        
        search.searchResultsUpdater = tableViewController
        search.delegate = self
        search.dimsBackgroundDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search".l
        search.searchBar.barTintColor = .black
        search.searchBar.tintColor = .black
        search.searchBar.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            search.searchBar.searchTextField.backgroundColor = .black
            search.searchBar.searchTextField.tintColor = .white
            search.searchBar.searchTextField.subviews.first?.backgroundColor = .black
            search.searchBar.searchTextField.textColor = .white
        }
        
        search.searchBar.delegate = tableViewController
        
        navigationItem.searchController = search
        addN("EndSearch", to: self, action: #selector(dismissSearch))
        addN("CancelPressed", to: self, action: #selector(cancelPressed))
        
        bar?.isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            bar?.scrollEdgeAppearance = app
            let appearances = [bar?.standardAppearance, bar?.scrollEdgeAppearance, bar?.compactAppearance]
            appearances.forEach { (currentAppearance) in
                currentAppearance?.backgroundImage = UIImage(named: "YeniGüzel")
                currentAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
                currentAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]

            }
            
        } else {
            bar?.barTintColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.3137254902, alpha: 1)

        }
        bar?.setBackgroundImage(UIImage(named: "YeniGüzel"),for: .default)
        bar?.isTranslucent = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        bar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        bar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        
    }

    
}
