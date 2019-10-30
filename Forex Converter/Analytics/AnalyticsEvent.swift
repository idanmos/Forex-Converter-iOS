/*
 *  Copyright 2019 Google LLC. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation

/// A struct for an Analytics Event which has a category and action, as well as an optional value
/// and label.
public struct AnalyticsEvent {

    // MARK: - Base struct

    var category: String
    var action: String
    var label: String?
    var value: NSNumber?
    var params: [String: String]?

    init(category: String,
         action: String,
         label: String? = nil,
         value: NSNumber? = nil,
         params: [String: String]? = nil) {
        self.category = category
        self.action = action
        self.label = label
        self.value = value
        self.params = params
    }
    
  // MARK: - Events

    // MARK: App
    
    static let categoryAppDelegate = "AppDelegate"
        
    static let applicationDidFinishLaunchingWithOptions = AnalyticsEvent(category: categoryAppDelegate,
                                                                         action: "applicationDidFinishLaunchingWithOptions")
    
    static let applicationWillResignActive = AnalyticsEvent(category: categoryAppDelegate,
                                                            action: "applicationWillResignActive")
    
    static let applicationDidEnterBackground = AnalyticsEvent(category: categoryAppDelegate,
                                                              action: "applicationDidEnterBackground")
    
    static let applicationWillEnterForeground = AnalyticsEvent(category: categoryAppDelegate,
                                                               action: "applicationWillEnterForeground")
    
    static let applicationDidBecomeActive = AnalyticsEvent(category: categoryAppDelegate,
                                                           action: "applicationDidBecomeActive")
    
    static let applicationWillTerminate = AnalyticsEvent(category: categoryAppDelegate,
                                                         action: "applicationWillTerminate")
    
    // MARL: - Device
    
    static let categoryDevice = "Device"
        
    static let userDidTakeScreenshotNotification = AnalyticsEvent(category: categoryDevice,
                                                                  action: "userDidTakeScreenshotNotification")
    
    static func deviceDetails(_ params: [String: String]) -> AnalyticsEvent {
        return AnalyticsEvent(category: categoryDevice, action: "deviceDetails", params: params)
    }
    
  // MARK: Display

  static let categoryDisplay = "Display"
    
  static let displaySelectFirst = AnalyticsEvent(category: categoryDisplay, action: "SelectFirst")
  static let displaySelectSecond = AnalyticsEvent(category: categoryDisplay, action: "SelectSecond")
  static let displaySelectThird = AnalyticsEvent(category: categoryDisplay, action: "SelectThird")
  static let displayChangeSecond = AnalyticsEvent(category: categoryDisplay, action: "ChangeSecond")
  static let displayChangeThird = AnalyticsEvent(category: categoryDisplay, action: "ChangeThird")

  // MARK: Keypad
    
  // MARK: Currencies List
    
    static let CurrenciesListCategory = "CurrenciesList"
    
    static let currenciesListSelectNumber = AnalyticsEvent(category: CurrenciesListCategory, action: "SelectNumber")
    static let currenciesListSelectDot = AnalyticsEvent(category: CurrenciesListCategory, action: "SelectDot")
    static let currenciesListClearAll = AnalyticsEvent(category: CurrenciesListCategory, action: "ClearAll")
    static let currenciesListDropLast = AnalyticsEvent(category: CurrenciesListCategory, action: "DropLast")
    
    static func currenciesListChangeLanguage(_ selectedLanguage: String) -> AnalyticsEvent {
    return AnalyticsEvent(category: CurrenciesListCategory,
                          action: "ChangeLanguage",
                          label: selectedLanguage)
        
    }
    
    static let currenciesListShare = AnalyticsEvent(category: CurrenciesListCategory, action: "share")
    
}
