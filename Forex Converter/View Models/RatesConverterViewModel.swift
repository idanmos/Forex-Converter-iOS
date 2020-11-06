//
//  RatesConverterViewModel.swift
//  Forex Converter
//
//  Created by Idan Moshe on 05/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class RatesConverterViewModel {
    
    var instagramStories: [InstagramStory] = []
    var currencies: [Currency] = []
        
    func fetchData(completionHandler: @escaping () -> Void) {
        NetworkManager.downloadXMLFile(url: Constants.endpointUrl, timeout: 20) { result in            
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let xmlParser = BankOfIsraelParser(data: data)
                xmlParser.parse()
                
                self.currencies.removeAll()
                self.currencies.append(contentsOf: xmlParser.getCurrencies())
                
                self.instagramStories.removeAll()
                
                for currency: Currency in self.currencies {
                    var title: String = ""
                    
                    if let localized: String = Locale.hebrewLocale.localizedString(forCurrencyCode: currency.currencyCode) {
                        title = "\(currency.unit) \(localized)"
                    } else {
                        let localizedCountry: String = CurrencyType(rawValue: currency.currencyCode)?.localizedCountry ?? ""
                        title = localizedCountry
                    }
                    
                    let story = InstagramStory(imageName: currency.currencyCode, title: title)
                    self.instagramStories.append(story)
                }
                
                DispatchQueue.main.async {
                    completionHandler()
                }
            case .failure(let error):
                debugPrint(#function, error)
            }
        }
    }
    
}
