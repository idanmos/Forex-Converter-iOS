//
//  FCNumericKeypadButton.swift
//  Forex Converter
//
//  Created by Idan Moshe on 27/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCNumericKeypadButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    
}
