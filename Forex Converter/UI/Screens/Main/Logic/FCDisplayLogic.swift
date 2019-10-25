//
//  FCDisplayLogic.swift
//  Forex Converter
//
//  Created by Idan Moshe on 07/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

protocol FCDisplayLogicDelegate: class {
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeActiveColorAtIndex currencyIndex: Int)
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeAsOfDate asOfDate: String)
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstTextField firstTextField: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondTextField secondTextField: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdTextField thirdTextField: String)
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstDescription firstDescription: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondDescription secondDescription: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdDescription thirdDescription: String)
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstCurrencyCode firstCurrencyCode: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondCurrencyCode secondCurrencyCode: String)
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdCurrencyCode thirdCurrencyCode: String)
}

class FCDisplayLogic {
    
    // MARK: - Declarations
    
    var firstCurrency: Currency!
    var secondCurrency: Currency!
    var thirdCurrency: Currency!
    
    private var currentValue: String = ""
    
    var activeLine: Int = Constants.kFirstCurrencyLine {
        willSet {
            self.delegate?.displayLogic(self, didChangeActiveColorAtIndex: newValue)
        }
    }
        
    private lazy var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    weak var delegate: FCDisplayLogicDelegate?
        
    // MARK: - General methods
    
    func setupData() {
        let first = FCDataSourceManager.shared().currencies[0]
        var second = FCDataSourceManager.shared().currencies[1]
        var third = FCDataSourceManager.shared().currencies[2]
        
        if let euro: Currency = FCDataSourceManager.shared().currencies.first(where: { (currency: Currency) -> Bool in
            return currency.currencyCode == "USD"
        }) {
            second = euro
        }
        
        if let usd: Currency = FCDataSourceManager.shared().currencies.first(where: { (currency: Currency) -> Bool in
            return currency.currencyCode == "EUR"
        }) {
            third = usd
        }
        self.setupData(first: first, second: second, third: third)
    }
    
    private func setupData(first: Currency, second: Currency, third: Currency) {
        self.firstCurrency = first
        self.secondCurrency = second
        self.thirdCurrency = third
        
        // As of date
        let asOfDate: String = ("FCCurrenciesTableViewController.LastUpdate".localized) + ": " + (FCDataSourceManager.shared().lastUpdate)
        
        // Amount
        var secondValue: String = ""
        var thirdValue: String = ""
        
        // Description
        var firstDescription: String = ""
        var secondDescription: String = ""
        var thirdDescription: String = ""
        
        // Currency code
        var firstCurrencyCode: String = ""
        var secondCurrencyCode: String = ""
        var thirdCurrencyCode: String = ""
        
        if self.firstCurrency != nil {
            firstCurrencyCode = firstCurrency.currencyCode
            firstDescription = "\(firstCurrency.name), \(firstCurrency.country)"
        }
        if self.secondCurrency != nil {
            secondValue = "0"
            secondCurrencyCode = secondCurrency.currencyCode
            secondDescription = "\(secondCurrency.name), \(secondCurrency.country)"
        }
        if self.thirdCurrency != nil {
            thirdValue = "0"
            thirdCurrencyCode = thirdCurrency.currencyCode
            thirdDescription = "\(thirdCurrency.name), \(thirdCurrency.country)"
        }
        
        self.delegate?.displayLogic(self, didChangeAsOfDate: asOfDate)
        
        self.delegate?.displayLogic(self, didChangeSecondTextField: secondValue)
        self.delegate?.displayLogic(self, didChangeThirdTextField: thirdValue)
        
        self.delegate?.displayLogic(self, didChangeFirstDescription: firstDescription)
        self.delegate?.displayLogic(self, didChangeSecondDescription: secondDescription)
        self.delegate?.displayLogic(self, didChangeThirdDescription: thirdDescription)
        
        self.delegate?.displayLogic(self, didChangeFirstCurrencyCode: firstCurrencyCode)
        self.delegate?.displayLogic(self, didChangeSecondCurrencyCode: secondCurrencyCode)
        self.delegate?.displayLogic(self, didChangeThirdCurrencyCode: thirdCurrencyCode)
    }
    
    private func currencyConvert(amountToExchange: Double, firstCurrency: Currency, secondCurrency: Currency) -> Double {
        let targetExchangeRate: Double = secondCurrency.rate
        var moneyAfterExchange: Double = 0.0
        
        if secondCurrency.currencyCode == CurrencyType.ILS.rawValue {
            moneyAfterExchange = firstCurrency.rate * amountToExchange
        } else {
            if firstCurrency.currencyCode != CurrencyType.ILS.rawValue && secondCurrency.currencyCode != CurrencyType.ILS.rawValue {
                moneyAfterExchange = amountToExchange * firstCurrency.rate / secondCurrency.rate
            } else {
                if Double(firstCurrency.unit) < targetExchangeRate {
                    moneyAfterExchange = amountToExchange / targetExchangeRate
                } else if Double(firstCurrency.unit) > targetExchangeRate {
                    moneyAfterExchange = amountToExchange * targetExchangeRate
                } else {
                    moneyAfterExchange = amountToExchange
                }
            }
        }
        return moneyAfterExchange
    }
    
    func didChangeValue(value: String) {
        self.currentValue = value
        
        guard value != "0" else {
            // Don't convert anything, just clear all
            self.delegate?.displayLogic(self, didChangeFirstTextField: "0")
            self.delegate?.displayLogic(self, didChangeSecondTextField: "0")
            self.delegate?.displayLogic(self, didChangeThirdTextField: "0")
            
            return
        }
        
        if let displayDoubleAmount = Double(value) {
            if let displayAmountFormatted: String = self.decimalFormatter.string(from: NSNumber(value: displayDoubleAmount)) {
                switch self.activeLine {
                case Constants.kFirstCurrencyLine:
                    self.delegate?.displayLogic(self, didChangeFirstTextField: displayAmountFormatted)
                case Constants.kSecondCurrencyLine:
                    self.delegate?.displayLogic(self, didChangeSecondTextField: displayAmountFormatted)
                case Constants.kThirdCurrencyLine:
                    self.delegate?.displayLogic(self, didChangeThirdTextField: displayAmountFormatted)
                default:
                    break
                }
            }
        }
        
        if let amountToExchange = Double(value) {
            switch self.activeLine {
            case Constants.kFirstCurrencyLine:
                self.convertAmount(amountToExchange,
                                   sourceCurrency: self.firstCurrency,
                                   convertTo: self.secondCurrency,
                                   andConvertTo: self.thirdCurrency)
            case Constants.kSecondCurrencyLine:
                self.convertAmount(amountToExchange,
                                   sourceCurrency: self.secondCurrency,
                                   convertTo: self.firstCurrency,
                                   andConvertTo: self.thirdCurrency)
            case Constants.kThirdCurrencyLine:
                self.convertAmount(amountToExchange,
                                   sourceCurrency: self.thirdCurrency,
                                   convertTo: self.firstCurrency,
                                   andConvertTo: self.secondCurrency)
            default:
                break
            }
        }
    }
    
    private func convertAmount(_ amountToExchange: Double, sourceCurrency: Currency, convertTo firstCurrency: Currency, andConvertTo secondCurrency: Currency) {
        let moneyAfterExchange_first: Double = self.currencyConvert(amountToExchange: amountToExchange,
                                                              firstCurrency: sourceCurrency,
                                                              secondCurrency: firstCurrency)
        
        let moneyAfterExchange_second: Double = self.currencyConvert(amountToExchange: amountToExchange,
                                                              firstCurrency: sourceCurrency,
                                                              secondCurrency: secondCurrency)
        
        let formatted_first: String = self.decimalFormatter.string(from: NSNumber(value: moneyAfterExchange_first)) ?? ""
        let formatted_second: String = self.decimalFormatter.string(from: NSNumber(value: moneyAfterExchange_second)) ?? ""
        
        
        switch self.activeLine {
            case Constants.kFirstCurrencyLine:
                self.delegate?.displayLogic(self, didChangeSecondTextField: formatted_first)
                self.delegate?.displayLogic(self, didChangeThirdTextField: formatted_second)
        case Constants.kSecondCurrencyLine:
            self.delegate?.displayLogic(self, didChangeFirstTextField: formatted_first)
            self.delegate?.displayLogic(self, didChangeThirdTextField: formatted_second)
        case Constants.kThirdCurrencyLine:
            self.delegate?.displayLogic(self, didChangeFirstTextField: formatted_first)
            self.delegate?.displayLogic(self, didChangeSecondTextField: formatted_second)
        default:
            break
        }
    }
    
    func changeCurrencies(newSecondCurrency: Currency? = nil, newThirdCurrency: Currency? = nil) {
        if let newSecondCurrency = newSecondCurrency {
            self.secondCurrency = newSecondCurrency
            
            self.delegate?.displayLogic(self, didChangeSecondCurrencyCode: self.secondCurrency.currencyCode)
            self.delegate?.displayLogic(self, didChangeSecondDescription: secondCurrency.name + ", " + secondCurrency.country)
        }
        if let newThirdCurrency = newThirdCurrency {
            self.thirdCurrency = newThirdCurrency
            
            self.delegate?.displayLogic(self, didChangeThirdCurrencyCode: self.thirdCurrency.currencyCode)
            self.delegate?.displayLogic(self, didChangeThirdDescription: thirdCurrency.name + ", " + thirdCurrency.country)
        }
        
        self.didChangeValue(value: self.currentValue)
    }
    
}
