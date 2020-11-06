//
//  BankOfIsraelParser.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class BankOfIsraelParser: NSObject {
    
    private var parser: XMLParser!
    private var elementName: String = ""
    
    private var currencies: [Currency] = []
    private var currency: Currency!
    
    var lastUpdate: String?
    
    init(data: Data) {
        super.init()
        self.parser = XMLParser(data: data)
        self.parser.delegate = self
    }
    
    func parse() {
        self.parser.parse()
    }
    
    // MARK: - General methods
    
    func getCurrencies() -> [Currency] {
        return self.currencies
    }

}

// MARK: - XMLParserDelegate

extension BankOfIsraelParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "CURRENCY" {
            self.currency = Currency()
            self.currency.date = Date()
        }
        
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "CURRENCY" {
            self.currency.localized()
            self.currencies.append(self.currency)
        } else if elementName == "CURRENCIES" {
            // End of parsing
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard data.isEmpty == false else { return }
        
        if self.elementName == "LAST_UPDATE" {
            self.lastUpdate = string
        } else if self.elementName == "CURRENCY" {
            //
        } else if self.elementName == "NAME" {
            self.currency.name = string
        } else if self.elementName == "UNIT" {
            self.currency.unit = Int(string)!
        } else if self.elementName == "CURRENCYCODE" {
            self.currency.currencyCode = string
        } else if self.elementName == "COUNTRY" {
            self.currency.country = string
        } else if self.elementName == "RATE" {
            self.currency.rate = Double(string)!
        } else if self.elementName == "CHANGE" {
            self.currency.change = Double(string)!
        }
    }
    
}
