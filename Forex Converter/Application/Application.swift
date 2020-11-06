//
//  Application.swift
//  Forex Converter
//
//  Created by Idan Moshe on 03/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class Application {
    
    enum SpecialCharacters {
        static let arrowUp: String = "↑"
        static let arrowDown: String = "↓"
        // static let smile: String = "😀"
    }
    
    enum GraphColors {
        static let positiveColor: UIColor = .systemGreen
        static let negativeColor: UIColor = .systemRed
    }
    
    enum RSS {
        static let globes: String = "https://www.globes.co.il/webservice/rss/rssfeeder.asmx/FeederNode?iID=2"
        static let cnbc: String = "https://www.cnbc.com/id/19746125/device/rss/rss.xml"
    }
    
}
