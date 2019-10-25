//
//  UIAlertController+Extensions.swift
//  Forex Converter
//
//  Created by Idan Moshe on 12/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func actionSheetWithItems<A : Equatable>(title: String?, items : [(title : String, value : A)], currentSelection : A? = nil, action : @escaping (A) -> Void) -> UIAlertController {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        for (var title, value) in items {
            if let selection = currentSelection, value == selection {
                // Note that checkmark and space have a neutral text flow direction so this is correct for RTL
                title = "✔︎ " + title
            }
            controller.addAction(
                UIAlertAction(title: title, style: .default) {_ in
                    action(value)
                }
            )
        }
        return controller
    }
    
    static func makeAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String?,
                          handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: handler))
        return alertController
    }
    
    static func makeAlert(title: String?,
                          message: String?,
                          cancelButtonTitle: String?,
                          firstHandler: ((UIAlertAction) -> Void)? = nil,
                          defaultButtonTitle: String?,
                          secondHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: firstHandler))
        alertController.addAction(UIAlertAction(title: defaultButtonTitle, style: .default, handler: secondHandler))
        return alertController
    }
    
}
