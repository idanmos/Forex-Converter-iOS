//
//  FCActivityView.swift
//  Forex Converter
//
//  Created by Idan Moshe on 27/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class LoaderView {
    
    static private let _view = FCActivityView(frame: UIScreen.main.bounds)
    
    static func show() {
        if var topMostController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topMostController.presentedViewController {
                topMostController = presentedViewController
            }
            self.show(onView: &topMostController.view)
        }
    }
    
    static func show(onView view: inout UIView) {
        view.addSubview(self._view)
        view.bringSubviewToFront(self._view)
    }
    
    static func hide() {
        self._view.removeFromSuperview()
    }
    
}

class FCActivityView: StoryboardCustomXibView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.containerView.layer.cornerRadius = 5.0
    }

}
