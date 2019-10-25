//
//  ThemeManager.swift
//  Forex Converter
//
//  Created by Idan Moshe on 21/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

enum ThemeManagerStyle: Int {
    case light = 1
    case dark = 2
    case unspecified = 3
}

class ThemeManager {
    
    @discardableResult static func restore() -> Bool {
        if #available(iOS 13.0, *) {
            let savedStyle = UserDefaults.standard.integer(forKey: "ThemeManagerStyle")
            if savedStyle == ThemeManagerStyle.light.rawValue {
                guard let window: UIWindow = AppDelegate.sharedDelegate().window else { return false }
                window.overrideUserInterfaceStyle = .light
                return true
            } else if savedStyle == ThemeManagerStyle.dark.rawValue {
                guard let window: UIWindow = AppDelegate.sharedDelegate().window else { return false }
                window.overrideUserInterfaceStyle = .dark
                return true
            }
        }
        return false
    }
    
    static func applyStyle(_ style: ThemeManagerStyle) {
        if #available(iOS 13.0, *) {
            guard let window: UIWindow = AppDelegate.sharedDelegate().window else { return }
            
            if style == .light {
                if window.traitCollection.userInterfaceStyle != .light {
                    window.overrideUserInterfaceStyle = .light
                }
            } else {
                if window.traitCollection.userInterfaceStyle != .dark {
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
}
