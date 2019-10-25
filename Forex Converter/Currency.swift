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
            return "Australia".localized
        case .USD:
            return "United States".localized
        case .CAD:
            return "Canada".localized
        case .GBP:
            return "UK".localized
        case .EGP:
            return "Egypt".localized
        case .ILS:
            return "Israel".localized
        case .JPY:
            return "Japan".localized
        case .EUR:
            return "European Union".localized
        case .DKK:
            return "Denmark".localized
        case .NOK:
            return "Norway".localized
        case .SEK:
            return "Sweden".localized
        case .ZAR:
            return "South Africa".localized
        case .CHF:
            return "Switzerland".localized
        case .JOD:
            return "Jordan".localized
        case .LBP:
            return "Lebanon".localized
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
            return "Dollar".localized
        case .GBP:
            return "British Pound".localized
        case .EGP:
            return "Egyptian Pound".localized
        case .ILS:
            return "Israeli Shekel".localized
        case .JPY:
            return "Japanse Yen".localized
        case .EUR:
            return "Euro".localized
        case .DKK, .NOK, .SEK:
            return "Krone".localized
        case .ZAR:
            return "South African Rand".localized
        case .CHF:
            return "Swiss Franc".localized
        case .JOD:
            return "Jordanian Dinar".localized
        case .LBP:
            return "Lebanese Pound".localized
        }
    }
    
}

struct Currency: Codable {
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
    
}

extension Currency {
    
    mutating func localized() {
        if let localized = CurrencyType(rawValue: self.currencyCode) {
            self.country = localized.localizedCountry
            self.name = localized.localizedName
        }
    }
    
}
