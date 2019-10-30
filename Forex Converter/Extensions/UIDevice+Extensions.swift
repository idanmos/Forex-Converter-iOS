//
//  Device+Extensions.swift
//  Forex Converter
//
//  Created by Idan Moshe on 18/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// Returns the device type code.
    class var deviceType: String {
      var sysinfo = utsname()
      uname(&sysinfo)
      return String(bytes: Data(bytes: &sysinfo.machine,
                                count: Int(_SYS_NAMELEN)),
                    encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    /// Whether or not the device is an iPhone. Otherwise, it is an iPad or iPod Touch.
    class var isPhone: Bool {
      return current.model == "iPhone"
    }
    
    class var deviceTypeDescription: String {
        switch current.userInterfaceIdiom {
        case .unspecified:
            return "unspecified"
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .tv:
            return "tv"
        case .carPlay:
            return "carPlay"
        @unknown default:
            return "unknown"
        }
    }
    
    class var deviceDetails: [String: String] {
        return ["name": current.name,
                "model": self.deviceType,
                "operationSystem": current.systemName,
                "version": current.systemVersion,
                "deviceType": self.deviceTypeDescription]
    }
    
}
