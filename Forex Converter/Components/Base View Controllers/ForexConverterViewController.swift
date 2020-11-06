//
//  ForexConverterViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 18/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

/// A base class for all non-Material view controllers to subclass, which will be extended to add
/// analytics tracking.
class ForexConverterViewController: VisibilityTrackingViewController {
    
    let analyticsReporter: AnalyticsReporter = AnalyticsReporterWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.analyticsReporter.setOptOut(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.analyticsReporter.trackScreenView(named: self.analyticsViewName)
    }

}

/// A wrapping class for VisibilityTrackingCollectionViewController, which will be extended to add analytics
/// tracking.
class ForexConverterCollectionViewController: VisibilityTrackingCollectionViewController {

  let analyticsReporter: AnalyticsReporter = AnalyticsReporterWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.analyticsReporter.setOptOut(true)
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.analyticsReporter.trackScreenView(named: self.analyticsViewName)
  }

}

/// A wrapping class for VisibilityTrackingTableViewController, which will be extended to add analytics
/// tracking.
class ForexConverterTableViewController: VisibilityTrackingTableViewController {

  let analyticsReporter: AnalyticsReporter = AnalyticsReporterWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.analyticsReporter.setOptOut(true)
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.analyticsReporter.trackScreenView(named: self.analyticsViewName)
  }

}
