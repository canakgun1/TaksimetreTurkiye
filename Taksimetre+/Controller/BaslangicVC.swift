//
//  BaslangicVC.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 15.01.2022.
//

import UIKit
import MapKit

class BaslangicVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKLocalSearchCompleterDelegate {
    
    var results: [MKLocalSearchCompletion]! = []
    
    var startText = ""

    @IBOutlet weak var konumumBtn: UIButton!
    @IBOutlet weak var vazgeçButton: UIButton!
    @IBOutlet weak var başlangıçView: RoundedView8!
    @IBOutlet weak var başlangıçTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        if CLLocationManager().location == nil {
            konumumBtn.isHidden = true
        } else {
            konumumBtn.isHidden = false
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        tap.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped(tap: UITapGestureRecognizer) {
        
        başlangıçTextField.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BaşlangıçCell", for: indexPath) as? YerBulCell {
            
            cell.anaLabel.attributedText = createHighlightedString(text: results[indexPath.row].title, rangeValues: results[indexPath.row].titleHighlightRanges)
            cell.detayLabel.text = results[indexPath.row].subtitle
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        başlangıçTextField.text = results[indexPath.row].title
        let request = MKLocalSearch.Request(completion: results[indexPath.row])
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            başlangıçAdı = self.results[indexPath.row].title
            başlangıç = response!.mapItems.first
            sonBaşlangıç = başlangıç
            postN("BaşlangıçDismissed", info: ["Date":Date().timeIntervalSince1970])
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        results = completer.results
        tableView.reloadData()

    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    @IBAction func konumumPressed(_ sender: UIButton) {
        sonBaşlangıç = nil
        başlangıçAdı = "Konumum"
        başlangıç = nil
        
        postN("BaşlıkDeğiştir")
        
        postN("BaşlangıçDismissed", info: ["Date":Date().timeIntervalSince1970])
        dismiss(animated: true, completion: nil)
    }
    @IBAction func vazgeçButtonPressed(_ sender: UIButton) {
        postN("BaşlangıçDismissed", info: ["Date":Date().timeIntervalSince1970])
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        searchCompleter.region = MKCoordinateRegion(center: (CLLocationManager().location ?? CLLocation(latitude: 41.036945, longitude: 28.985832)).coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        searchCompleter.queryFragment = başlangıçTextField.text!
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print(searchCompleter.isSearching)
        }
    }
}

var sonBaşlangıç: MKMapItem? = nil {
    
    didSet {
        
        postN("BaşlıkDeğiştir")
        
    }
    
}
