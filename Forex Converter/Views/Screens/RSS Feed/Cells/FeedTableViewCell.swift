//
//  FeedTableViewCell.swift
//  Forex Converter
//
//  Created by Idan Moshe on 04/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let identifier: String = "FeedTableViewCell"
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: RSSItem) {
        self.feedTitleLabel.text = item.title
        self.feedDateLabel.text = item.publicationDate
    }
    
}
