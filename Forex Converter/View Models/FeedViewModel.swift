//
//  FeedViewModel.swift
//  Forex Converter
//
//  Created by Idan Moshe on 05/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    var items: [RSSItem] = []
    
    func fetchRSS(completionHandler: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            let parser = RSSParser(url: Application.RSS.globes)
            parser.startParsing()
            
            self.items.removeAll()
            self.items.append(contentsOf: parser.getFeed())
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
}
