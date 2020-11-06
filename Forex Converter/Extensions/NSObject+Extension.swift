//
//  NSObject+Extension.swift
//  Forex Converter
//
//  Created by Idan Moshe on 05/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension NSObject {
    func getClassName() -> String {
        return String(describing: self.classForCoder)
    }
}
