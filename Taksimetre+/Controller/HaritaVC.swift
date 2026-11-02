//
//  ViewController.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 20.04.2021.
//

import UIKit
import CoreLocation
import MapKit
import StoreKit
import GoogleMobileAds
import FirebaseFirestore

class HaritaVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate, MKLocalSearchCompleterDelegate,  UBottomSheetCoordinatorDelegate, UITableViewDelegate, SKProductsRequestDelegate {
    
    @IBOutlet weak var loadingView: RoundedView12!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchItemButton: UIBarButtonItem!
    @IBOutlet weak var ayarlarButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var search: UISearchController!
    var routes: [MKRoute] = []
    var currentPolyline: MKPolyline! {
        didSet {
            rotaAdı = routes.first(where: {$0.polyline == currentPolyline})?.name ?? ""
            rotaSüresi = Int(((routes.first(where: {$0.polyline == currentPolyline})?.expectedTravelTime ?? 0) as Double).rounded(.up))
            
            rotaUzunluğu = Int(((routes.first(where: {$0.polyline == currentPolyline})?.distance ?? 0) as Double).rounded(.up))
            enKısaRotaSüresi = Int(((routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime}).first?.expectedTravelTime ?? 0) as Double).rounded(.up))
            postN("ŞimdiAyarla")
            
        }
    }
    
    var destinationComp: MKLocalSearchCompletion!
    var tableViewController: YerBulTVC!
    var sheetCoordinator: UBottomSheetCoordinator!
    var backView: PassThroughView?
    var menu: MenuVC!
    
    var oldu = false
    
    private var interstitial: InterstitialAd? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapTapped)))
        
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        
        navBarAyarla()
        updateLocation()
        
        addN("XPressed", to: self, action: #selector(xPressed))
        addN("MenüyüBüyüt", to: self, action: #selector(menüyüBüyüt))
        addN("MenüOrta", to: self, action: #selector(menüOrta))
        addN("ShowAd", to: self, action: #selector(showAd))
        addN("ParaAlındı", to: self, action: #selector(para))
        
//        for s1 in ["Ankara", "Antalya", "Muğla", "Çeşme", "İstanbul", "İzmir"] {
//            for s2 in ["Ankara", "Antalya", "Muğla", "Çeşme", "İstanbul", "İzmir"] {
//                Firestore.firestore().collection("Kullanim").document("\(s1) - \(s2)").setData(["Türk" : 0, "Yabancı" : 0])
//            }
//        }
        
        
        
        if !paraAlındı {
            let request = Request()
            InterstitialAd.load(with:HARITA_ID, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
            })
        }
        
        şehirleriAl()
        
        if al(forKey: "CanaParaYollandı") != 5 {
            canaYolla()
            yaz(5, forKey: "CanaParaYollandı")
        } else {
            canaYolla()
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.performSegue(withIdentifier: "reklamsizSegue", sender: self)
//        }
        
    }
    
    @objc func showAd() {
        
        if Date().timeIntervalSince1970 - lastDate.timeIntervalSince1970 > 1 {
            yaz(al(forKey: "RequestSayısı") + 1, forKey: "RequestSayısı")
            lastDate = Date()
        }
        
        
        if al(forKey: "RequestSayısı") % 11 == 10 {
            kullanıcı?.sorulanlar["Puan"]?.append(Date().günAyYılSaatDk)
            SKStoreReviewController.requestReview()
            yaz(al(forKey: "RequestSayısı") + 1, forKey: "RequestSayısı")
            return
        } else {
            if interstitial != nil && !paraAlındı {
                interstitial!.present(from: self)
            } else {
                print("Ad wasn't ready")
            }
        }
        
        
        if !paraAlındı {
            let request = Request()
            InterstitialAd.load(with:HARITA_ID, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
            })
        }
        
        
    }
    
    func IAP() {
        
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.loadingView.isHidden = false
        self.IAPSor()
        
    }
    
    
    
    @objc func para() {
        
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        loadingView.isHidden = true
        
    }
    
    func canaYolla() {
        // Deprecated
        return
        
    }
    
    @objc func menüyüBüyüt() {
        sheetCoordinator.setPosition(100, animated: true)
        
    }
    
    @objc func menüOrta() {
        sheetCoordinator.setPosition(view.frame.height - 323, animated: true)
        
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocation()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        yaz(al(forKey: "NewRequestSayısı") + 1, forKey: "NewRequestSayısı")
        
        tableView.deselectRow(at: indexPath, animated: true)
        taksiTipi = 1
        
        if tableView == tableViewController.tableView, let suggestion = tableViewController.results?[indexPath.row] {
            search.isActive = false
            search.searchBar.text = suggestion.title
            let requestSayısı = al(forKey: "NewRequestSayısı")
            print("Para Alındı: \(paraAlındı)\tTürk: \(türk())\tRequest Sayısı: \(requestSayısı)")
            guard paraAlındı || (requestSayısı % 9 != 4) else {
//                paraAlertGöster(suggestion)
//                Review için silindi
                kullanıcı?.sorulanlar["Puan"]?.append(Date().günAyYılSaatDk)
                SKStoreReviewController.requestReview()
                tableViewSelectCompletion(suggestion)
                return
            }
            
            tableViewSelectCompletion(suggestion)
            
            
        }
        
    }
    
    func tableViewSelectCompletion(_ suggestion: MKLocalSearchCompletion) {
        
        if menüGösteriliyor {
            sheetCoordinator.removeSheetInstantly()
            başlangıçAdı = "Konumum"
            menüGösteriliyor = false
        }
        randoms = [:]
        routes = []
        currentPolyline = nil
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        destinationComp = suggestion
        yerEkle(yer: suggestion, source: nil, yeni: true)
        navigationItem.searchController = nil
        navigationItem.title = "Route".l
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    
    
    func yerEkle(yer: MKLocalSearchCompletion, source: MKMapItem?, yeni: Bool) {
        
        let request = MKLocalSearch.Request(completion: yer)
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { res, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if res!.mapItems == [] {
                return
            }
            
            let placemark = res!.mapItems.first!.placemark
            let coor = placemark.coordinate
            
            if yeni {
                varışKoordinatı = coor
                varışBaşlığı = placemark.name ?? ""
                self.updateMenu(name: placemark.name ?? "", destination: placemark.location!, placemark: placemark, mapItem: res!.mapItems.first!)
            }
            
            
            let pointA = MKPointAnnotation()
            pointA.coordinate = coor
            pointA.title = res!.mapItems.first!.name
            
            let annotation = MKMarkerAnnotationView(annotation: pointA, reuseIdentifier: "DestinationAnnotation")
            annotation.glyphTintColor = .clear
            annotation.markerTintColor = .blue
            if #available(iOS 13.0, *) {

                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "DestinationAnnotation")

            }
            
            self.mapView.addAnnotation(annotation.annotation!)
            
            if let coor = annotation.annotation?.coordinate {
                self.mapView.setRegion(MKCoordinateRegion(center: coor, latitudinalMeters: 400, longitudinalMeters: 400), animated: true)
                self.rotayıÇiz(destination: res!.mapItems.first!, source: source, yeni: yeni)
            }
            
            
            
            
            
        }
        
    }
    
    func rotayıÇiz(destination: MKMapItem, source: MKMapItem?, yeni: Bool) {
        
        let locs = locationManager.location ?? destination.placemark.location!
        
        var defAlındı = false
        
        if locationManager.location == nil {
            defAlındı = true
        }
        
        
        
        let req = MKDirections.Request()
        req.destination = destination
        
        
        if source == nil {
            req.source = MKMapItem(placemark: MKPlacemark(coordinate: locs.coordinate))
            şehriAyarla(başlangıç: MKMapItem(placemark: MKPlacemark(coordinate: locs.coordinate)))
        } else {
            req.source = source!
            şehriAyarla(başlangıç: source!)
        }
        
        if sonBaşlangıç != nil {
            
            req.source = sonBaşlangıç
            şehriAyarla(başlangıç: sonBaşlangıç!)
            
        }
        
        req.requestsAlternateRoutes = true
        
        let kullanılanSource = req.source ?? MKMapItem(placemark: MKPlacemark(coordinate: locs.coordinate))
        let sourceTitle = (kullanılanSource.placemark.title?.contains("nited") ?? true || kullanılanSource.placemark.title?.contains("irleşik") ?? true) ? yakınŞehirBul(kullanılanSource) : kullanılanSource.placemark.title ?? "?"
        
        let dir = MKDirections(request: req)
        rotaYükleniyor = true
        
        kullanimYaz(from: req.source, to: req.destination)
        
        dir.calculate { res, error in
            rotaYükleniyor = false
            if let error = error {
                print(error.localizedDescription)
                self.sheetCoordinator?.removeSheet()
                başlangıçAdı = "Konumum"
                menüGösteriliyor = false
                postN("XPressed")
                self.alert(başlık: "Rota Oluşturulamadı", mesaj: "Girdiğiniz başlangıç ve varış noktaları arasında uygun bir rota yok.")
                return
            }
            if res == nil || res!.routes.isEmpty{
                return
            }
            
            let newRoutes = twoRoutes(of: res!.routes)
            
            self.routes = newRoutes
            
            var nums: [CLLocationCoordinate2D] = []
            
            for p in 0..<(self.routes.first?.polyline.pointCount)! {
                
                nums.append((self.routes.first?.polyline.points()[p].coordinate)!)
                
            }
            
            newRoutes.forEach { r in
                if self.currentPolyline == nil {
                    self.currentPolyline = r.polyline
                }
                // BackOverlay Ayarla - Baştan
                self.mapView.addOverlay(r.polyline, level: .aboveRoads)
                let coor = r.polyline.points()[r.polyline.pointCount / 2].coordinate
                let point = self.mapView.convert(coor, toPointTo: self.view)
                let annotation = DakikaAnnotation()
                annotation.routeID = newRoutes.firstIndex(of: r)!
                annotation.coordinate = r.polyline.middlePoint.coordinate
                self.mapView.addAnnotation(annotation)
                
            }
            self.currentPolyline = newRoutes.sorted(by: {$0.ücret < $1.ücret}).first!.polyline
            
            
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.mapView.setVisibleMapRect(MKPolygon(points: self.currentPolyline.points(), count: self.currentPolyline.pointCount).boundingMapRect, edgePadding: .init(top: 50, left: 35, bottom: 323, right: 35), animated: true)
            
            self.mapView.setNeedsDisplay()
            self.mapView.setNeedsLayout()
            // BackOverlay Ayarla - Rota Oluşturma
            let o = self.mapView.overlays
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlays(o.filter({$0 !== self.currentPolyline}), level: .aboveRoads)
            
            self.mapView.insertOverlay(self.currentPolyline, at: self.mapView.overlays.count, level: .aboveRoads)
            
            if defAlındı && yeni {
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.removeAnnotations(self.mapView.annotations.filter({$0 is DakikaAnnotation}))
            }
            
            let selectedRoute = self.routes.first(where: {$0.polyline == self.currentPolyline})!
            rota = selectedRoute
            rotaÜcreti = selectedRoute.ücret
            rotaKm = selectedRoute.distance
            
            
            let userLocation = locs
            
            if defAlındı && yeni {
                self.menu.distanceLabel.isHidden = true
                self.menu.ücretLabel.isHidden = true
            } else {
                self.menu.distanceLabel.isHidden = false
                self.menu.ücretLabel.isHidden = false

            }
            
            kullanıcı?.rotalar.append(Rota(tarih: Date(), başlangıç: sourceTitle, bitiş: destination.placemark.title ?? "?", başlangıçŞehri: yakınŞehirBul(kullanılanSource), bitişŞehri: yakınŞehirBul(destination), koordinatlar: ["Başlangıç" : ["Latitude" : kullanılanSource.placemark.coordinate.latitude, "Longitude" : kullanılanSource.placemark.coordinate.longitude], "Bitiş" : ["Latitude" : destination.placemark.coordinate.latitude, "Longitude" : destination.placemark.coordinate.longitude]]))
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is DakikaAnnotation {
            
            guard currentPolyline != nil else {return MKAnnotationView()}
            let index = routes.firstIndex(where: {$0.polyline == currentPolyline})!
            let dkAn = annotation as! DakikaAnnotation
            

            let middleRect = CGRect(x: -75, y: -43.5, width: 75, height: 43.5)
            let dakikaView = DakikaView(frame: middleRect)
            
            dakikaView.isUserInteractionEnabled = false
            let annotationView = MKAnnotationView()
            let dak = DakikaAnnotation()
            annotationView.annotation = dak
            dakikaView.image.alpha = 1.0
            dakikaView.image.image = UIImage(named: dkAn.routeID! == index ? "LacivertDakika" : "MinuteBlue")!
            dakikaView.minuteLabel.text = "\(formatTime(Int((routes[dkAn.routeID!].expectedTravelTime / 60).rounded(.up))))"
            annotationView.addSubview(dakikaView)
            return annotationView
        }
        
        if annotation is MKUserLocation {
            return nil
        }
        let marker = mapView.dequeueReusableAnnotationView(withIdentifier: "DestinationAnnotation") as? MKMarkerAnnotationView
        
        marker?.markerTintColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.3137254902, alpha: 1)
        
        return marker
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let product = response.products.first!
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    @IBAction func ayarlarButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingsVC {
            destination.haritaVC = self
        }
    }
    
}

var TX_LOC = CLLocation(latitude: 0, longitude: 0)

//global bir variable yap location diye. location manager çalışıyorsa o konum olsun. çalışmıyorsa kullanıcı mesela eminönüne gitmek istiyosa location eminönü olsun arabayla kesin gidilebildiğinden emin olmak için ama oluştur düğmesi enabled olmasın. daha sonra başlangıç konumu kısmından kullanıcı kendi istediği yeri girsin ve source da belli olunca oluştur enabled olsun, rota çizilsin. aynı konumken de rota çizilir ama gözükmez
var lastDate = Date()
