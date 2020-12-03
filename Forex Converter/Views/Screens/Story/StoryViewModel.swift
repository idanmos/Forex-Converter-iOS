//
//  StoryViewModel.swift
//  Forex Converter
//
//  Created by Idan Moshe on 19/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class StoryViewModel {
    
    var currencies: [Currency] = [] {
        didSet {
            self.observerHandler()
        }
    }
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
//    private var observerHandler: (Any)->Void = { arg in }
    private var observerHandler: () -> Void = {}
    
    func registerForUpdates(completionHandler: @escaping () -> Void) {
        self.observerHandler = completionHandler
    }
    
    func getSelectedCurrency() -> Currency {
        self.currencies[self.selectedIndexPath.item]
    }
    
}
