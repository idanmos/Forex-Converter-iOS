//
//  AlertHelpViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 22/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class AlertHelpViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var closeCompletionBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        if UIAccessibility.isReduceTransparencyEnabled == false {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
            blurEffectView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.insertSubview(blurEffectView, at: 0)
        }
    }
    
    @IBAction private func onClosePRess(_ sender: Any) {
        self.dismiss(animated: true, completion: self.closeCompletionBlock)
    }
    
    func setOnCloseEvent(completion: (() -> Void)? = nil) {
        self.closeCompletionBlock = completion
    }

}

extension AlertHelpViewController {
    
    static func makeViewController() -> AlertHelpViewController {
        let helpViewController = AlertHelpViewController(nibName: "AlertHelpViewController", bundle: nil)
        helpViewController.view.frame = UIScreen.main.bounds
        helpViewController.modalPresentationStyle = .overFullScreen
        
        if #available(iOS 13.0, *) {
            helpViewController.overrideUserInterfaceStyle = .light
        }
        
        return helpViewController
    }
    
}
