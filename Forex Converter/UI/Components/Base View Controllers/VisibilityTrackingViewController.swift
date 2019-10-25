//
//  FCBaseViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 18/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

/// A view controller that tracks the visibility of its view.
class VisibilityTrackingViewController: UIViewController {
        
    // Tracks the visiblity of the view. This property is set to true in viewWillAppear, and false in
    // viewWillDisappear.
    public private(set) var isViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isViewVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewVisible = false
    }

}

/// A  collection view controller that tracks the visibility of its view.
class VisibilityTrackingCollectionViewController: UICollectionViewController {

  // Tracks the visiblity of the view. This property is set to true in viewWillAppear, and false in
  // viewWillDisappear.
  public private(set) var isViewVisible = false

  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.isViewVisible = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.isViewVisible = false
  }

}

/// A  table view controller that tracks the visibility of its view.
class VisibilityTrackingTableViewController: UITableViewController {

  // Tracks the visiblity of the view. This property is set to true in viewWillAppear, and false in
  // viewWillDisappear.
  public private(set) var isViewVisible = false

  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.isViewVisible = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.isViewVisible = false
  }

}
