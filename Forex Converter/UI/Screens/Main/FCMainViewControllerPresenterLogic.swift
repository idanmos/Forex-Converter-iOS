//
//  FCMainViewControllerPresenterLogic.swift
//  Forex Converter
//
//  Created by Idan Moshe on 06/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

protocol FCMainViewControllerDelegate: class {
    func mainViewControllerLogicDidSuccess(_ mainViewControllerLogic: FCMainViewControllerLogic)
    
    func mainViewControllerLogicDidFail(_ mainViewControllerLogic: FCMainViewControllerLogic,
                                        didFailWithError error: Error)
}

struct FCMainViewControllerLogic {
    
    weak var delegate: FCMainViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    func fetchCurrencies() {
        if let savedData: Data = FCFileManager.load(fileName: "currency.xml") {
            if !savedData.isEmpty {
                self.handleResponseData(savedData)
            }
        }
        
        FCNetworkManager.downloadXMLFile(url: Constants.endpointUrl, timeout: 20) { result in
            LoaderView.hide()
            
            switch result {
            case .success(let data):
                // Reset all
                AppDelegate.sharedDelegate().responseData = nil
                FCDataSourceManager.shared().currencies.removeAll()
                
                if let data = data {
                    self.handleResponseData(data)
                    
                    FCFileManager.replaceContentOfFile(fileName: "currency.xml", contents: data)
                }
            case .failure(let error):
                self.delegate?.mainViewControllerLogicDidFail(self, didFailWithError: error)
            }
        }
    }
    
    // MARK: - General methods
    
    private func handleResponseData(_ responseData: Data) {
        let xmlParser = FCXMLParser(data: responseData)
        
        xmlParser.completionHandler =  {
            // Finish parsing
            FCDataSourceManager.shared().addIsraeliNewShekel()
            self.delegate?.mainViewControllerLogicDidSuccess(self)
        }
        
        xmlParser.parse()
    }
    
}
