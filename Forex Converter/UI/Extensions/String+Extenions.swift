//
//  String+Extenions.swift
//  Forex Converter
//
//  Created by Idan Moshe on 12/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: Constants.kPreferredLanguageKey) {} else {
            UserDefaults.standard.set(Constants.kHebrewLanguageValue, forKey: Constants.kPreferredLanguageKey)
            UserDefaults.standard.synchronize()
        }
        
        let language: String = UserDefaults.standard.string(forKey: Constants.kPreferredLanguageKey)!
        let path: String = Bundle.currentBundle.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)
        
        let translation = NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        return translation
    }
    
    /*
    /// Returns the localized string matching with a key matching `self`. See ScienceJournalStrings
    /// for actual string lookup. If a string is not found in a non-English language, the English
    /// string will be returned instead.
    var localized: String {
      /* guard let bundle = Bundle.stringsBundle else {
        print("[Localization] Error opening strings bundle.")
        // Couldn't find the strings bundle, return the string key. This is not a good option for the
        // UI of the app, but if we hit this, there's a serious configuration problem.
        return self
      } */
        
      let bundle = Bundle.currentBundle

      // Get the current preferred language or set it to English as a fallback if we can't find one.
      let preferredLanguage = NSLocale.preferredLanguages.first ?? "en_US"
      // Get the lanuage code from the preferred language.
      let languageComponents = NSLocale.components(fromLocaleIdentifier: preferredLanguage)
      let languageCode = languageComponents[NSLocale.Key.languageCode.rawValue]

      if let languagePath = bundle.path(forResource: languageCode, ofType: "lproj"),
          let langBundle = Bundle(path: languagePath) {
        // We found the preferred language.
        return langBundle.localizedString(forKey: self, value: "", table: nil)
      } else if let languagePath = bundle.path(forResource: "en", ofType: "lproj"),
          let langBundle = Bundle(path: languagePath) {
        // We found English as a backup.
        return langBundle.localizedString(forKey: self, value: "", table: nil)
      } else {
        // We found nothing, unfortunately all we can do here is return.
        return self
      }
    }
 */
    
}
