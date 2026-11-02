//
//  Keychain.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 29.08.2022.
//

import Security
import UIKit

class KeyChain {

    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

func yaz(_ sayı: Int, forKey: String) {
    
    let data = Data(from: sayı)
    KeyChain.save(key: forKey, data: data)
        
}

func al(forKey: String) -> Int {
    
    let val = UserDefaults.standard.integer(forKey: forKey)
    if val != 0 {
        UserDefaults.standard.set(0, forKey: forKey)
        yaz(val, forKey: forKey)
        return val
    }
    
    if let receivedData = KeyChain.load(key: forKey) {
        return receivedData.to(type: Int.self)
    }
    return 0
}

