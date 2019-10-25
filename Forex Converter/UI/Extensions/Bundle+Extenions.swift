//
//  Bundle+Extenions.swift
//  Forex Converter
//
//  Created by Idan Moshe on 12/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// Returns the current bundle, based on the AppDelegate class. For open-source, this will always
    /// be equivalent to Bundle.main.
    static var currentBundle: Bundle = {
      return Bundle(for: AppDelegateProvider.self)
    }()
    
}
