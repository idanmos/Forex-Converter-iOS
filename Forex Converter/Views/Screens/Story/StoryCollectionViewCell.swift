//
//  StoryCollectionViewCell.swift
//  Forex Converter
//
//  Created by Idan Moshe on 19/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: StoryCollectionViewCell.self)
    
    @IBOutlet weak var currentMonthView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
//        self.currentMonthView.isHidden = true
        
//        self.currentMonthView.layer.cornerRadius = self.currentMonthView.frame.height/2
//        self.currentMonthView.layer.borderWidth = 3
//        self.currentMonthView.layer.borderColor = UIColor.purple.cgColor
//        self.currentMonthView.layer.masksToBounds = true
//        self.currentMonthView.clipsToBounds = true
        
        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
        self.imageView.layer.borderWidth = 3.0
//        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
    }
    
    func configure(currency: Currency, isSelectedCurrency: Bool) {
        self.imageView.image = UIImage(named: "\(currency.currencyCode)")
        self.imageView.layer.borderColor = isSelectedCurrency ? UIColor.systemGreen.cgColor : UIColor.black.cgColor
        
        self.titleLabel.textColor = isSelectedCurrency ? .systemGreen : .black
        self.titleLabel.text = currency.currencyCode
        
        if currency.currencyCode == CurrencyType.JPY.rawValue ||
            currency.currencyCode == CurrencyType.CHF.rawValue {
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.contentMode = .redraw
        }
    }

}
