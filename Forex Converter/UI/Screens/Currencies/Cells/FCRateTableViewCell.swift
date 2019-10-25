//
//  FCRateTableViewCell.swift
//  Forex Converter
//
//  Created by Idan Moshe on 01/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCRateTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    // MARK: - Declaration
    
    static let identifier: String = "FCRateTableViewCell"
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - General methods
    
    func updateUI(currency: Currency) {
        self.countryNameLabel.text = CurrencyType(rawValue: currency.currencyCode)?.localizedCountry
        
        if let flagImage = UIImage(named: currency.currencyCode) {
            self.flagImageView.image = flagImage
        }
        
        let text = "\(currency.sign) \(currency.unit) = " + "\(CurrencyType.ILS.sign) \(currency.rate)"
        self.amountLabel.text = text
    }
    
}
