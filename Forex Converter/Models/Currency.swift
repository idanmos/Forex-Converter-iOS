//
//  Currency.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import Foundation

enum CurrencyType: String {
    
    case AUD
    case USD
    case GBP
    case ILS
    case JPY
    case EUR
    case CAD
    case DKK
    case NOK
    case ZAR
    case SEK
    case CHF
    case JOD
    case LBP
    case EGP
    
    var localizedCountry: String {
        switch self {
        case .AUD:
            return "Australia"
        case .USD:
            return "United States"
        case .CAD:
            return "Canada"
        case .GBP:
            return "UK"
        case .EGP:
            return "Egypt"
        case .ILS:
            return "Israel"
        case .JPY:
            return "Japan"
        case .EUR:
            return "European Union"
        case .DKK:
            return "Denmark"
        case .NOK:
            return "Norway"
        case .SEK:
            return "Sweden"
        case .ZAR:
            return "South Africa"
        case .CHF:
            return "Switzerland"
        case .JOD:
            return "Jordan"
        case .LBP:
            return "Lebanon"
        }
    }
    
    var sign: String {
        switch self {
        case .USD, .CAD, .AUD:
            return "$"
        case .GBP, .EGP:
            return "£"
        case .ILS:
            return "₪"
        case .JPY:
            return "¥"
        case .EUR:
            return "€"
        case .DKK, .NOK, .SEK:
            return "kr"
        case .ZAR:
            return "R"
        case .CHF:
            return "₣"
        case .JOD:
            return "JD"
        case .LBP:
            return "LL"
        }
    }
    
    var localeIdentifier: String {
        switch self {
        case .USD, .AUD:
            return "en_US"
        case .CAD:
            return "en_CA"
        case .GBP:
            return "en_GB"
        case .EGP:
            return "ar_EG"
        case .ILS:
            return "he_IL"
        case .JPY:
            return "ja_JP"
        case .EUR:
            return "es_ES"
        case .DKK, .NOK, .SEK:
            return "da_DK"
        case .ZAR:
            return "af_ZA"
        case .CHF:
            return "gsw_CH"
        case .JOD:
            return "ar_JO"
        case .LBP:
            return "ar_LB"
        }
    }
    
    var localizedName: String {
        switch self {
        case .AUD, .USD, .CAD:
            return "Dollar"
        case .GBP:
            return "British Pound"
        case .EGP:
            return "Egyptian Pound"
        case .ILS:
            return "Israeli Shekel"
        case .JPY:
            return "Japanse Yen"
        case .EUR:
            return "Euro"
        case .DKK, .NOK, .SEK:
            return "Krone"
        case .ZAR:
            return "South African Rand"
        case .CHF:
            return "Swiss Franc"
        case .JOD:
            return "Jordanian Dinar"
        case .LBP:
            return "Lebanese Pound"
        }
    }
    
}

struct Currency: Codable {
    var date: Date?
    var name: String = ""
    var unit: Int = 0
    
    var currencyCode: String = "" {
        didSet {
            self.sign = CurrencyType(rawValue: currencyCode)?.sign ?? ""
        }
    }
    
    var country: String = ""
    var rate: Double = 0.0
    var change: Double = 0.0
    var sign: String = ""
    
    lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: CurrencyType(rawValue: currencyCode)?.localeIdentifier ?? "en_US")
        return formatter
    }()
    
    static func getIsraeliCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "he_IL")
        return formatter
    }
    
    static func getIsraeliShekel() -> Currency {
        let ILS = CurrencyType.ILS
        
        let currency = Currency(date: Date(),
                                name: ILS.localizedName,
                                unit: 1,
                                currencyCode: ILS.rawValue,
                                country: ILS.localizedCountry,
                                rate: 1,
                                change: 1,
                                sign: ILS.sign,
                                currencyFormatter: Currency.getIsraeliCurrencyFormatter())
        
        return currency
    }
    
}

extension Currency {
    
    mutating func localized() {
        if let localized = CurrencyType(rawValue: self.currencyCode) {
            self.country = localized.localizedCountry
            self.name = localized.localizedName
        }
    }
    
}
