//
//  RatesConverterTableViewCell.swift
//  Forex Converter
//
//  Created by Idan Moshe on 06/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class RatesConverterTableViewCell: UITableViewCell {
    
    static let identifier: String = "RatesConverterTableViewCell"
    
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet private weak var middleLabel: UILabel!
    @IBOutlet private weak var LeftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(currency: Currency, textFieldText: String?) {
        var right: String = ""
        
        if let localized: String = Locale.hebrewLocale.localizedString(forCurrencyCode: currency.currencyCode) {
            right = localized
        } else {
            let localizedCountry: String = CurrencyType(rawValue: currency.currencyCode)?.localizedCountry ?? ""
            right = localizedCountry
        }
        
        self.rightLabel.text = right
        
        var middle: String = ""
        
        if let text = textFieldText, let amount = Double(text) {
            let numberFormatter = NumberFormatter.numberFormatter
            // numberFormatter.currencyCode = currency.currencyCode
            if let formattedAmount = numberFormatter.string(from: NSNumber(value: amount/currency.rate)) {
                middle = "\(formattedAmount)"
            } else {
                middle = "\(amount/currency.rate)"
            }
        }
        
        self.middleLabel.text = middle
        
        self.LeftLabel.text = currency.sign
    }
    
}
