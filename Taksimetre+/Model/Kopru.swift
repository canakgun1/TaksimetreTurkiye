//
//  Kopru.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 28.08.2022.
//

import CoreLocation

enum Kopru: String {
    
    case T15
    case FSM
    case YSS
    case OSM
    case ÇAN
    
}

let köprüler: [Kopru : CLLocationCoordinate2D] =
[
    .T15 : CLLocationCoordinate2D(latitude: 41.0411382, longitude: 29.038793800000036),
    .FSM : CLLocationCoordinate2D(latitude: 41.09151699999999, longitude: 29.067550100000005),
    .YSS : CLLocationCoordinate2D(latitude: 41.199281699999986, longitude: 29.119712700000008),
    .OSM : CLLocationCoordinate2D(latitude: 40.738295099999995, longitude: 29.512897700000025),
    .ÇAN : CLLocationCoordinate2D(latitude: 40.3511399, longitude: 26.613791499999991)
]

let köprüÜcretleri: [Kopru : Double] =
[
    .T15 : 0,
    .FSM : 0,
    .YSS : 0,
    .OSM : 0,
    .ÇAN : 0
]
