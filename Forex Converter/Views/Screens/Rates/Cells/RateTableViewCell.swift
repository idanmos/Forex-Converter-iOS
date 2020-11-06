//
//  RateTableViewCell.swift
//  Forex Converter
//
//  Created by Idan Moshe on 03/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    
    static let identifier: String = "RateTableViewCell"
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(currency: Currency) {
        if let date = currency.date {
            let formattedTime: String = DateFormatter.timeFormatter.string(from: date)
            self.dateLabel.text = formattedTime
        } else {
            self.dateLabel.text = ""
        }
        
        self.rateLabel.text = "\(CurrencyType.ILS.sign) \(currency.rate)"
        
        if let localized: String = Locale.hebrewLocale.localizedString(forCurrencyCode: currency.currencyCode) {
            self.currencyNameLabel.text = "\(currency.unit) \(localized)"
        } else {
            let localizedCountry: String = CurrencyType(rawValue: currency.currencyCode)?.localizedCountry ?? ""
            self.currencyNameLabel.text = localizedCountry
        }
        
        if currency.change >= 0.0 {
            self.changeLabel.textColor = Application.GraphColors.positiveColor
            self.changeLabel.text = "\(Application.SpecialCharacters.arrowUp) \(currency.change)"
        } else {
            self.changeLabel.textColor = Application.GraphColors.negativeColor
            self.changeLabel.text = "\(Application.SpecialCharacters.arrowDown) \(currency.change)"
        }
    }
    
}
