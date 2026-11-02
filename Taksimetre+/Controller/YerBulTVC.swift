//
//  YerBulTVC.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 22.04.2021.
//

import UIKit
import MapKit

class YerBulTVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    var results: [MKLocalSearchCompletion]! = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YerCell", for: indexPath) as! YerBulCell

        cell.anaLabel.attributedText = createHighlightedString(text: results[indexPath.row].title, rangeValues: results[indexPath.row].titleHighlightRanges)
        cell.detayLabel.text = results[indexPath.row].subtitle
//        cell.logoImage.image = UIImage(named: "pinLogo")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        if !searchController.isActive {
//            postN("CancelPressed")
//        }
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        searchCompleter.region = MKCoordinateRegion(center: (CLLocationManager().location ?? CLLocation(latitude: 41.036945, longitude: 28.985832)).coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        searchCompleter.queryFragment = searchController.searchBar.text!
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print(searchCompleter.isSearching)
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        postN("CancelPressed")
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        results = completer.results
        tableView.reloadData()

    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
