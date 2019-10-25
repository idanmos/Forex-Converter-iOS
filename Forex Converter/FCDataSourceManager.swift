//
//  FCDataSourceManager.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCDataSourceManager: NSObject {
    
    private static let _instance = FCDataSourceManager()
    class func shared() -> FCDataSourceManager {
        return self._instance
    }
    
    var lastUpdate: String = ""
    var currencies: [Currency] = []
    
    func addIsraeliNewShekel() {
        guard AppDelegate.sharedDelegate().isUsingCache == false else { return }
//        guard let first: Currency = self.currencies.first, first.currencyCode != "ILS" else { return }
        
        var insCurrency = Currency()
        insCurrency.name = "Shekel"
        insCurrency.currencyCode = "ILS"
        insCurrency.country = "Israel"
        insCurrency.rate = 1
        insCurrency.unit = 1
        insCurrency.change = 0
        
        if let localized = CurrencyType(rawValue: insCurrency.currencyCode) {
            insCurrency.country = localized.localizedCountry
            insCurrency.name = localized.localizedName
        }
        
        self.currencies.insert(insCurrency, at: 0)
    }
    
}
