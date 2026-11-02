//
//  Functions.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 17.05.2021.
//

import Foundation
import MapKit
import StoreKit

// MARK: Functions

func formatTime(_ time: Int) -> String {
    
    let saat = (time - (time % 60)) / 60
    let dakika = time - saat * 60
    
    if saat == 0 {
        
        return "\(dakika) " + "mins".l
        
    } else if dakika == 0 {
        
        return "\(saat) " + "hours".l
        
    } else {
        
        return "\(saat) " + "h".l + " \(dakika) " + "mins".l
        
    }
    
}

func formatClock(hour: Int, minute: Int) -> String {
    
    var h = "\(hour)"
    var m = "\(minute)"
    
    if hour < 10 {
        
        h = "0\(hour)"
        
    }
    
    if minute < 10 {
        
        m = "0\(minute)"
        
    }
    
    return h + "." + m
    
}

func _print(_ items: Any...) {
    
    print("\(items)" + "--Output")
    
}

func twoRoutes(of routes: [MKRoute]) -> [MKRoute] {
    
    var fastest = routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime}).first!
    var shortest = routes.sorted(by: {$0.distance < $1.distance}).first!
    
    if shortest == fastest {
        return [shortest]
    } else {
        return [shortest, fastest]
    }
    
}

func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
    
    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold) ]
    let highlightedString = NSMutableAttributedString(string: text)
    let ranges = rangeValues.map { $0.rangeValue }
    
    for range in ranges {
        
        if range.location + range.length > text.count {
            
            let ran = ranges.filter { r in
                (r.location + r.length > text.count) == false
            }.first
            if ran == nil {
                return NSAttributedString(string: text)
            } else {
                return NSAttributedString(string: text, attributes: attributes)
            }
        }
        highlightedString.addAttributes(attributes, range: range)
    }
    
    return highlightedString
}

// MARK: Extensions

extension Double {
    
    func rounded(decimals: Int) -> Double {
        
        guard decimals > 0 else { return self }
        let num = pow(10, Double(decimals))
        return ((self * num).rounded() / num)
        
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}

extension CLLocationCoordinate2D {
    
    enum CodingKeys: String, CodingKey {
        
        case latitude
        case longitude
        
    }
    
//    public func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//
//    }
//
//    public init(from decoder: Decoder) throws {
//
//        let values = try! decoder.container(keyedBy: CodingKeys.self)
//
//        latitude = try! values.decode(Double.self, forKey: .latitude)
//        longitude = try! values.decode(Double.self, forKey: .longitude)
//
//    }
    
}

extension MKPolyline {
    
    var middlePoint: MKMapPoint {
//        points()[Int((Double(pointCount) / 2).rounded(.up) -  1)]
        let rand = Int.random(in: 0..<pointCount)
        if randoms[self] != nil {
            return points()[randoms[self]!]
        } else {
            randoms[self] = rand
            return points()[rand]
        }
//        return points[rand]
    }
    
}

var randoms: [MKPolyline : Int]! = [:]

extension HaritaVC {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else {return}
        sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                   delegate: self)
        
        menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu") as! MenuVC
       
        menu.sheetCoordinator = sheetCoordinator
        
        sheetCoordinator.addSheet(menu, to: self, didContainerCreate: { container in
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
        
        sheetCoordinator.setCornerRadius(10)
        
        
    }
    private func addBackDimmingBackView(below container: UIView){
        backView = PassThroughView()
        self.view.insertSubview(backView!, belowSubview: container)
        backView!.translatesAutoresizingMaskIntoConstraints = false
        backView!.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backView!.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        backView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
//        self.addBackDimmingBackView(below: container!)
        self.sheetCoordinator.addDropShadowIfNotExist()
        self.handleState(state)
    }

    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        handleState(state)
    }

    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        })
    }
    
    func handleState(_ state: SheetTranslationState){
        switch state {
        case .progressing(_, let percent):
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        case .finished(_, let percent):
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        default:
            break
        }
    }
    
}

extension HaritaVC {
    
    @objc func mapTapped(_ tap: UITapGestureRecognizer) {
        if tap.state == .recognized {
            // Get map coordinate from touch point
            let touchPt: CGPoint = tap.location(in: mapView)
            var iconPoints: [CGPoint] = []
            for icon in mapView.annotations.filter({$0 is DakikaAnnotation}) {
                iconPoints.append(mapView.convert(icon.coordinate, toPointTo: view))
            }
            var broken = false
            for point in iconPoints {

                if touchPt.x < point.x && touchPt.x > point.x - 75 && touchPt.y < point.y && touchPt.y > point.y - 43.5 {
                    
                    currentPolyline = routes.first(where: {mapView.convert($0.polyline.middlePoint.coordinate, toPointTo: view) == point})?.polyline
//                    currentPolyline = (mapView.overlays.filter({$0 is MKPolyline}) as! [MKPolyline])[iconPoints.firstIndex(of: point)!]

                    mapView.setNeedsDisplay()
                    mapView.setNeedsLayout()
                    self.mapView.removeAnnotations(self.mapView.annotations.filter({$0 is DakikaAnnotation}))
                    routes.forEach { r in
                        
                        let annotation = DakikaAnnotation()
                        annotation.routeID = routes.firstIndex(of: r)!
                        annotation.coordinate = r.polyline.middlePoint.coordinate
                        self.mapView.addAnnotation(annotation)
                        if r.polyline == currentPolyline {
                            
                        }
                        
                    }
                    // BackOverlay Ayarla - İkona Dokununca Yenileme
                    let o = mapView.overlays
                    mapView.removeOverlays(mapView.overlays)
                    mapView.addOverlays(o.filter({$0 !== currentPolyline}), level: .aboveRoads)
                    
                    mapView.insertOverlay(currentPolyline, at: mapView.overlays.count, level: .aboveRoads)
                    
                    let selectedRoute = routes.first(where: {mapView.convert($0.polyline.middlePoint.coordinate, toPointTo: view) == point})!
                    rota = selectedRoute
                    rotaÜcreti = selectedRoute.ücret
                    rotaKm = selectedRoute.distance
                    
                    _print("269: \(rotaKm)")
                    
                    
                    broken = true
                    break
                }
            }
            if broken {
                return
            }
            let coord: CLLocationCoordinate2D = mapView.convert(touchPt, toCoordinateFrom: mapView)
            let maxMeters: Double = meters(fromPixel: 10, at: touchPt)
            var nearestDistance: Float = MAXFLOAT
            var nearestPoly: MKPolyline? = nil
            // for every overlay ...
            // BackOverlay Ayarla - Rotaya Dokununca Gerçekleri Bulma
            for overlay: MKOverlay in mapView.overlays {
                if (overlay is MKPolyline) {
                    let distance: Float = Float(distanceOf(pt: MKMapPoint(coord), toPoly: overlay as! MKPolyline))
                    if distance < nearestDistance {
                        nearestDistance = distance
                        nearestPoly = overlay as? MKPolyline
                    }

                }
            }
            

            if Double(nearestDistance) <= maxMeters {
                if currentPolyline == nearestPoly {
                    return
                }
                
                
                currentPolyline = nearestPoly ?? nil
                mapView.setNeedsDisplay()
                mapView.setNeedsLayout()
                self.mapView.removeAnnotations(self.mapView.annotations.filter({$0 is DakikaAnnotation}))
                routes.forEach { r in
                    if self.currentPolyline == nil {
                        self.currentPolyline = r.polyline
                    }
                    
                    let annotation = DakikaAnnotation()
                    annotation.routeID = routes.firstIndex(of: r)!
                    annotation.coordinate = r.polyline.middlePoint.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                }
                // BackOverlay Ayarla - Rotaya Dokununca Yenileme
                let o = mapView.overlays
                mapView.removeOverlays(mapView.overlays)
                mapView.addOverlays(o.filter({$0 !== currentPolyline}), level: .aboveRoads)
                
                mapView.insertOverlay(currentPolyline, at: mapView.overlays.count, level: .aboveRoads)
//                mapView.bringSubviewToFront(p1)
                
                let selectedRoute = routes.first(where: {$0.polyline == currentPolyline})!
                rota = selectedRoute
                rotaÜcreti = selectedRoute.ücret
                rotaKm = selectedRoute.distance
                
                _print("327: \(rotaKm)")

            }
        }
    }
    

    private func distanceOf(pt: MKMapPoint, toPoly poly: MKPolyline) -> Double {
        var distance: Double = Double(MAXFLOAT)
        for n in 0..<poly.pointCount - 1 {
            let ptA = poly.points()[n]
            let ptB = poly.points()[n + 1]
            let xDelta: Double = ptB.x - ptA.x
            let yDelta: Double = ptB.y - ptA.y
            if xDelta == 0.0 && yDelta == 0.0 {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest: MKMapPoint
            if u < 0.0 {
                ptClosest = ptA
            }
            else if u > 1.0 {
                ptClosest = ptB
            }
            else {
                ptClosest = MKMapPoint(x: ptA.x + u * xDelta, y: ptA.y + u * yDelta)
            }

            distance = min(distance, ptClosest.distance(to: pt))
        }
        return distance
    }

    private func meters(fromPixel px: Int, at pt: CGPoint) -> Double {
        let ptB = CGPoint(x: pt.x + CGFloat(px), y: pt.y)
        let coordA: CLLocationCoordinate2D = mapView.convert(pt, toCoordinateFrom: mapView)
        let coordB: CLLocationCoordinate2D = mapView.convert(ptB, toCoordinateFrom: mapView)
        return MKMapPoint(coordA).distance(to: MKMapPoint(coordB))
    }
    
}
// MARK: Classes

class OriginalUIImage: UIImage {

    convenience init?(named name: String) {
        guard let image = UIImage(named: name),
              nil != image.cgImage else {
                    return nil
        }
        self.init(cgImage: image.cgImage!)
    }

    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        // both return statements work:
        return self
        // return super.withRenderingMode(.alwaysOriginal)
    }

}

