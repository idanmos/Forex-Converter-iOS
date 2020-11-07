//
//  RatesViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 03/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RatesViewController: ForexConverterTableViewController {
    
    @IBOutlet private weak var bannerView: GADBannerView!
    
    private lazy var ratesViewModel: RatesViewModel = {
        let viewModel = RatesViewModel()
        return viewModel
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "משוך לרענון")
        control.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        return control
    }()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "שערי מטבע"
        
        self.tableView.register(UINib(nibName: RateTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RateTableViewCell.identifier)
                
        self.refreshControl = self.refresh
                
        self.fetchData()
        
        let bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        bannerView.adUnitID = Constants.GoogleAdMob_AdUnitId_Banner
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        self.tableView.tableHeaderView = bannerView
        
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.fetchData), userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - General methods
    
    @objc private func fetchData() {
        debugPrint(#file, #function)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.ratesViewModel.fetchCurrencies { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
        
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratesViewModel.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.identifier, for: indexPath) as! RateTableViewCell
        let currency: Currency = self.ratesViewModel.currencies[indexPath.row]
        cell.configure(currency: currency)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
