//
//  UIView+Extensions.swift
//  Forex Converter
//
//  Created by Idan Moshe on 30/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeAsCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func centerAtSuperview() {
        if let _ = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
        }
    }
    
  func makePopAnimation() {
    CATransaction.begin()
    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    animation.values = [0, 0.2 * 1, -0.2 * 1, 0.2 * 1, 0]
    animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animation.duration = CFTimeInterval(0.3)
    animation.isAdditive = true
    animation.repeatCount = 1
    animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0.1)
    self.layer.add(animation, forKey: "pop")
    CATransaction.commit()
  }
  
}
