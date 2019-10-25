//
//  FCKeypadLogic.swift
//  Forex Converter
//
//  Created by Idan Moshe on 07/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

protocol FCKeypadLogicDelegate: class {
    func keypadLogic(_ keypadLogic: FCKeypadLogic, didChangeValue value: String)
}

class FCKeypadLogic {
    
    weak var delegate: FCKeypadLogicDelegate?
    
    var processor = CalculatorProcessor()
    
    var showDecimal = true {
        didSet {
            self.processor.automaticDecimal = !showDecimal
        }
    }
        
    func onButtonPressed(senderTag: Int) {
        switch (senderTag) {
        case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
            let output = processor.storeOperand(senderTag-1)
            self.delegate?.keypadLogic(self, didChangeValue: output)
        case CalculatorKey.decimal.rawValue:
            let output = processor.addDecimal()
            self.delegate?.keypadLogic(self, didChangeValue: output)
        case CalculatorKey.clear.rawValue:
            let output = processor.clearAll()
            self.delegate?.keypadLogic(self, didChangeValue: output)
        case CalculatorKey.delete.rawValue:
            let output = processor.deleteLastDigit()
            self.delegate?.keypadLogic(self, didChangeValue: output)
        case (CalculatorKey.multiply.rawValue)...(CalculatorKey.add.rawValue):
            let output = processor.storeOperator(senderTag)
            self.delegate?.keypadLogic(self, didChangeValue: output)
        case CalculatorKey.equal.rawValue:
            let output = processor.computeFinalValue()
            self.delegate?.keypadLogic(self, didChangeValue: output)
            break
        default:
            break
        }
    }
    
}
