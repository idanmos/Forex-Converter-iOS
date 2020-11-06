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

// MARK: - Base protocol

/// A protocol for view controllers to provide a constant string name for analytics purposes.
protocol AnalyticsTrackable: class {
  var analyticsViewName: String { get }
}

// MARK: - View controller extensions

// MARK: Base classes

extension ForexConverterViewController: AnalyticsTrackable {
  @objc open var analyticsViewName: String {
    assert(false, "ERROR: View controller does not have a custom analyticsViewName.")
    return String(describing: type(of: self))
  }
}

extension ForexConverterCollectionViewController: AnalyticsTrackable {
  @objc open var analyticsViewName: String {
    assert(false, "ERROR: View controller does not have a custom analyticsViewName.")
    return String(describing: type(of: self))
  }
}

extension ForexConverterTableViewController: AnalyticsTrackable {
  @objc open var analyticsViewName: String {
    assert(false, "ERROR: View controller does not have a custom analyticsViewName.")
    return String(describing: type(of: self))
  }
}

// MARK: - Custom ViewControllers Names

extension RatesViewController {
  override var analyticsViewName: String { return "Rates" }
}

extension RatesConverterViewController {
  override var analyticsViewName: String { return "Rates Converter" }
}

extension FeedTableViewController {
    override var analyticsViewName: String { return "RSS Feed" }
}
