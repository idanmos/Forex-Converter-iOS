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
import Firebase

/// No-op implementation of analytics reporter.
 class AnalyticsReporterBase: AnalyticsReporter {

  public func setOptOut(_ isOptedOut: Bool) {}
    
    public func trackScreenView(named screenName: String) {
        Analytics.setScreenName(screenName, screenClass: nil)
    }
    
    public func track(_ analyticsEvent: AnalyticsEvent) {
        #if DEBUG
        print(analyticsEvent)
        #endif
        
        var analytics: [String: Any] = [:]
        analytics["category"] = analyticsEvent.category
        
        if let label: String = analyticsEvent.label {
            analytics["label"] = label
        }
        
        if let value: NSNumber = analyticsEvent.value {
            analytics["value"] = value
        }
        
        Analytics.logEvent(analyticsEvent.action, parameters: analytics)
    }

}
