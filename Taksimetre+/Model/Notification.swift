//
//  Notification.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 4.05.2021.
//

import Foundation

func postN(_ name: String) {
    NotificationCenter.default.post(name: Notification.Name(name), object: nil)
}

func postN(_ name: String, info: [AnyHashable : Any]?) {
    NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: info)
}

func removeN(_ name: String, of observer: Any) {
    NotificationCenter.default.removeObserver(observer, name: Notification.Name(name), object: nil)
}

func addN(_ name: String, to observer: Any, action: Selector) {
    NotificationCenter.default.addObserver(observer, selector: action, name: Notification.Name(name), object: nil)
}


