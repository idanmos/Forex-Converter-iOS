//
//  Constants.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit
import Foundation

class Constants {
    
    static let GoogleAdMobId: String = "ca-app-pub-6158225633661411~1730593880"
    static let GoogleAdMob_AdUnitId_Test: String = "ca-app-pub-3940256099942544/2934735716"
    static let GoogleAdMob_AdUnitId_Banner: String = "ca-app-pub-6158225633661411/6562411873"
    
    static let endpointStringUrl: String = "https://www.boi.org.il/currency.xml"
    static let endpointUrl = URL(string: Constants.endpointStringUrl)!
    
    static let kFirstCurrencyLine: Int = 1
    static let kSecondCurrencyLine: Int = 2
    static let kThirdCurrencyLine: Int = 3
    
    static var activeTextColor: UIColor {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .orange
        }
    }
    
    static var inactiveTextColor: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        } else {
            return .black
        }
    }
    
    static let kPreferredLanguageKey: String = "kPreferredLanguageKey"
    static let kHebrewLanguageValue: String = "he"
    static let kEnglishLanguageValue: String = "en"
    static let kArabicLanguageValue: String = "ar"
}

enum Localization: String {
    case he_IL
    case en_US
}

enum CalculatorKey: Int {
    case zero = 1
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case decimal
    case clear
    case delete
    case multiply
    case divide
    case subtract
    case add
    case equal
}
