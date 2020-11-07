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
    
    private let ratesConverterViewModel = RatesConverterViewModel()
    private let reuseIdentifier: String = "reuseIdentifier"
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "מחשבון המרה"
        
        self.textField.text = "100"
        
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self.textField, action: #selector(self.textField.resignFirstResponder))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyboardToolBar.items = [flexibleSpace, doneButton]
        self.textField.inputAccessoryView = keyboardToolBar
        
        self.tableView.register(UINib(nibName: RatesConverterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RatesConverterTableViewCell.identifier)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        let bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        bannerView.adUnitID = Constants.GoogleAdMob_AdUnitId_Banner
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        self.tableView.tableHeaderView = bannerView
        
        self.fetchData()
        
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
        
        self.ratesConverterViewModel.fetchData { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
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
        cell.configure(currency: currency, textFieldText: self.textField.text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

extension RatesConverterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let _ = Double(textField.text ?? "") else { return }
        self.tableView.reloadData()
    }
    
}
