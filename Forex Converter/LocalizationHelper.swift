//
//  LocalizationHelper.swift
//  Forex Converter
//
//  Created by Idan Moshe on 24/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class LocalizationHelper {
    
    static func requestAvailableLanguages() -> [String] {
        return ["he", "en", "ar"]
    }
    
    static func requestPreferredLanguage() -> String? {
        return Bundle.preferredLocalizations(from: self.requestAvailableLanguages()).first
    }
    
}
