//
//  Localize.swift
//  Taksimetre+
//
//  Created by CAN AKGUN on 21.08.2022.
//

import Foundation

extension String {
    var l: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

func türk() -> Bool {
    
    NSLocale.current.languageCode == "tr"
    
}
