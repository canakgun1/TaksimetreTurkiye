//
//  MenuVC.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 30.04.2021.
//

import UIKit
import MapKit

class MenuVC: UIViewController, Draggable, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var topSpaceConst: NSLayoutConstraint!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipSegmented: UISegmentedControl!
    @IBOutlet weak var tarifeLabel: UILabel!
    @IBOutlet weak var controlContainerView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ücretLabel: UILabel!
    var sheetCoordinator: UBottomSheetCoordinator?
    var adres = ""
    var rowCount = 0
    var sonGüncelleme = Date()
    var şimdikiSüre: Int = 0
    var oluşturuluyor = false
    var rows: [[String]]! {
        didSet {
            rowCount = rows.count
            menuTableView.reloadData()
        }
    }
    var mapItem: MKMapItem! {
        didSet {
            guard isViewLoaded && mapItem != nil else {return}
            rows = mapItem.menuData()
            menuTableView.reloadData()
        }
    }
    
    @IBOutlet weak var backView: RoundedView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var başlangıçButton: UIButton!
    @IBOutlet weak var başlangıçLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var konumumButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = []
        let item = mapItem
        mapItem = item
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.allowsSelection = true
        menuTableView.reloadData()
        removeN("BaşlangıçDismissed", of: self)
        addN("BaşlangıçDismissed", to: self, action: #selector(başlangıçUpdate))
        addN("ÜcretChanged", to: self, action: #selector(ücretDeğişti))
        addN("BaşlıkDeğiştir", to: self, action: #selector(konumTitleUpdate))
        print("#1", controlContainerView.subviews)
        controlContainerView.bringSubviewToFront(menuTableView.superview!)
        print("#2", controlContainerView.subviews)
        konumTitleUpdate()
        
        segmentedAyarla()
    }
    
    func segmentedAyarla() {
    
        tipSegmented.setTitle("Yellow".l, forSegmentAt: 0)
        tipSegmented.setTitle("Blue".l, forSegmentAt: 1)
        tipSegmented.setTitle("Black".l, forSegmentAt: 2)
        tipLabel.text = "Taxi type:".l
        
    }
    
    @objc func ücretDeğişti() {
        
        if şehir != "İstanbul" {
            
            topSpaceConst.constant = 30.0
            tipLabel.isHidden = true
            tipSegmented.isHidden = true
            
        } else {
            
            topSpaceConst.constant = 70.0
            tipLabel.isHidden = false
            tipSegmented.isHidden = false
            
        }
        
        var txt = (String(format: "%.2f", (rotaÜcreti + (rota?.rotaKöprüÜcretleri ?? 0)).rounded(decimals: 2)) + " ₺")
        print(rotaÜcreti)
        print(rota?.rotaKöprüÜcretleri)
        if türk() {
            txt = txt.replacingOccurrences(of: ".", with: ",")
        }
            

        
        ücretLabel.text = txt
        var distText = ""
        if rotaKm >= 1000 {
            distText = "\((rotaKm / 1000).rounded(decimals: 1)) km"
        } else {
            switch rotaKm {
            case let m where m <= 50:
                distText = "En fazla 50 m"
            default:
                distText = "\(Int((rotaKm / 10).rounded() * 10)) m"
            }
            
        }
        if türk() {
            distText = distText.replacingOccurrences(of: ".", with: ",")
        }
        
        postN("ShowAd")
        distanceLabel.text = distText
        _print("Ücret: \(txt)\nKm: \(rotaKm)")
        
        if türk() {
            tarifeLabel.text = "\(şehir) tarifesi"
        } else {
            tarifeLabel.text = "Fares for: \(şehir)"
        }
       
        
    }
    
    @objc func konumTitleUpdate() {
        if sonBaşlangıç != nil {
            konumumButton.setTitle(sonBaşlangıç!.name, for: .normal)
        }
        else if CLLocationManager().location == nil && başlangıçAdı == "Konumum" {
            
            konumumButton.setTitle("Choose Location".l, for: .normal)
            
        } else {
            if başlangıçAdı == "Konumum" {
                konumumButton.setTitle("Choose Location".l, for: .normal)
            } else {
                konumumButton.setTitle(başlangıç != nil ? başlangıçAdı : "Choose Location".l, for: .normal)
            }
            
        }
    }
    
    @objc func başlangıçUpdate(notification: NSNotification) {
        
        if son!["Date"] as! Double == notification.userInfo!["Date"] as! Double {
            
            son = notification.userInfo
            return
        }
        son = notification.userInfo
        
        konumTitleUpdate()
        
        
        let harita = parent as! HaritaVC
        harita.routes = []
        harita.currentPolyline = nil
        randoms = [:]
        harita.mapView.removeOverlays(harita.mapView.overlays)
        harita.mapView.removeAnnotations(harita.mapView.annotations)
        print("BAŞLANGIÇ UPDATE", notification.userInfo)
        harita.yerEkle(yer: harita.destinationComp, source: başlangıç, yeni: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sheetCoordinator?.startTracking(item: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellReuse", for: indexPath) as? MenuCell {
            
            cell.titleLabel.text = rows![indexPath.row][0].l
            cell.detailMenuLabel.text = rows![indexPath.row][1]
            let backView = UIView()
            backView.backgroundColor = .clear
            cell.selectedBackgroundView = backView
            if rows[indexPath.row][0] == "Address" {
                cell.detailMenuLabel.textColor = .white
            } else {
                cell.detailMenuLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rows[indexPath.row][0] == "Address" {
            return CGFloat(70 + (mapItem.placemark.adres().components(separatedBy: "\n").count - 1) * 30)
        } else {
            return 70
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mapItem != nil {
            tableViewHeight.constant = CGFloat(rowCount * 70 + (mapItem.placemark.adres().components(separatedBy: "\n").count - 1) * 30)
        } else {
            tableViewHeight.constant = CGFloat(rowCount * 70 + 30)
        }
        
        view.setNeedsLayout()
        
//        if rowCount <= 1 {
//
//            tableView.isHidden = true
//
//        } else {
//
//            tableView.isHidden = true
//
//        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if rows[indexPath.row][0] == "Phone Number" {
            if let url = URL(string: "tel://\(rows[indexPath.row][1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else if rows[indexPath.row][0] == "Website" {
            if let url = URL(string: rows[indexPath.row][1]), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func konumumButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "BaşlangıçSegue", sender: self)
        
    }
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        
        guard !rotaYükleniyor else { return }
        taksiTipi = 1
        
        sheetCoordinator?.removeSheet()
        başlangıçAdı = "Konumum"
        menüGösteriliyor = false
        postN("XPressed")
        
        
    }
    
    @IBAction func tipSegmentedChanged(_ sender: UISegmentedControl) {
        
        
        let no = sender.selectedSegmentIndex
        taksiTipi = no + 1
        if #available(iOS 13.0, *) {
            sender.selectedSegmentTintColor = colors[no]
        }
        
        if let rota = rota {
            var txt = (String(format: "%.2f", (rota.ücret + rota.rotaKöprüÜcretleri ?? 0).rounded(decimals: 2)) + " ₺")
                
            if türk() {
                txt = txt.replacingOccurrences(of: ".", with: ",")
            }
            ücretLabel.text = txt
            ücretLabel.textColor = colors[no]
            
            if no == 2 {
                ücretLabel.textColor = .white
//                ücretLabel.shadowColor = .white
//                ücretLabel.shadowOffset = CGSize(width: -0.15, height: -0.15)
                
            }
        }
        
    }
}

var başlangıç: MKMapItem? = nil
var başlangıçAdı: String! = "Konumum"
var son: [AnyHashable:Any]? = ["Date":Date().timeIntervalSince1970]
var varışBaşlığı: String = ""
var varışKoordinatı: CLLocationCoordinate2D!
var rotaAdı: String = ""
var rotaSüresi: Int = 0
var rotaUzunluğu: Int = 0
var enKısaRotaSüresi: Int = 0
var rotaYükleniyor = false
