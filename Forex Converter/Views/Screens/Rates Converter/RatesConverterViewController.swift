//
//  RatesConverterViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 05/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RatesConverterViewController: ForexConverterViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var storyCollectionView: StoryCollectionView!
    @IBOutlet private weak var selectedFlagImageView: UIImageView!
    @IBOutlet private weak var selectedFlagCurrencySignLabel: UILabel!
    
    private let ratesConverterViewModel = RatesConverterViewModel()
    private let reuseIdentifier: String = "reuseIdentifier"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "מחשבון המרה"
        
        self.textField.text = "100"
        
        self.selectedFlagImageView.layer.borderWidth = 1.0
        self.selectedFlagImageView.layer.borderColor = UIColor.black.cgColor
        
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.textField, action: #selector(self.textField.resignFirstResponder))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyboardToolBar.items = [flexibleSpace, doneButton]
        self.textField.inputAccessoryView = keyboardToolBar
        
        self.tableView.register(UINib(nibName: RatesConverterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RatesConverterTableViewCell.identifier)
        self.tableView.keyboardDismissMode = .onDrag
                        
        let bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        bannerView.adUnitID = Constants.GoogleAdMob_AdUnitId_Banner
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        self.tableView.tableHeaderView = bannerView
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.fetchData()
        
        self.storyCollectionView.registerForUpdates { [weak self] (currency: Currency) in
            guard let self = self else { return }
            
            self.selectedFlagImageView.image = UIImage(named: currency.currencyCode)
            self.selectedFlagCurrencySignLabel.text = currency.sign
            
            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
        }
    }
    
    // MARK: - General methods
    
    private func fetchData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.ratesConverterViewModel.fetchData { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            
            self.storyCollectionView.appendCurrencies(self.ratesConverterViewModel.currencies)
        }
    }
        
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RatesConverterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratesConverterViewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatesConverterTableViewCell.identifier, for: indexPath) as! RatesConverterTableViewCell
        let currency: Currency = self.ratesConverterViewModel.currencies[indexPath.row]
        
        cell.configure(convert: self.storyCollectionView.getSelectedCurrency(),
                       to: currency,
                       text: self.textField.text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lhs: Currency = self.storyCollectionView.getSelectedCurrency()
        let rhs: Currency = self.ratesConverterViewModel.currencies[indexPath.row]
        return (lhs.country == rhs.country) ? 0.0 : 50.0
    }
    
}

// MARK: - UITextFieldDelegate

extension RatesConverterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let _ = Double(textField.text ?? "") else { return }
        self.tableView.reloadData()
    }
    
}
