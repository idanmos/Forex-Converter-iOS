//
//  FCCurrenciesTableViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 01/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCCurrenciesTableViewController: ForexConverterTableViewController {
    
    var refferal: String = ""
    var sourceViewController: FCMainViewController!
    
    var imageSize: CGSize = .zero
    
    var previousCurrencyCode: String = ""
    
    private lazy var currencies: [Currency] = {
        var _currencies = FCDataSourceManager.shared().currencies
        if _currencies.count > 0 {
            if _currencies[0].currencyCode == "ILS" {
                _currencies.removeFirst()
            }
            _currencies.sort { (first: Currency, second: Currency) -> Bool in
                return first.country < second.country
            }
        }
        return _currencies
    }()
    
    /* lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .prominent
        search.placeholder = " Search..."
        search.sizeToFit()
        search.isTranslucent = false
        search.backgroundImage = UIImage()
        search.delegate = self
        
        if #available(iOS 13.0, *) {
            search.overrideUserInterfaceStyle = self.traitCollection.userInterfaceStyle
        } else {
            // Fallback on earlier versions
        }
        return search
    }() */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        var title = "FCCurrenciesTableViewController.Title".localized
        if self.refferal.count > 0 && self.previousCurrencyCode.count > 0 {
            title += " - "
            title += "replace".localized
        }
        self.title = title
                 
        // self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 13, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeScreen))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(self.closeScreen))
        }
        
        /* if self.refferal.count == 0 && self.previousCurrencyCode.count == 0 {
            self.tableView.addSubview(self.searchBar)
        } */
    }
    
    // MARK: - General methods
    
    @objc private func closeScreen() {
        if let _ = self.navigationController?.popViewController(animated: true) {
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency: Currency = self.currencies[indexPath.row]
        
        /* let cell = tableView.dequeueReusableCell(withIdentifier: FCRateTableViewCell.identifier, for: indexPath) as! FCRateTableViewCell
        
        cell.updateUI(currency: currency) */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = currency.currencyCode == self.previousCurrencyCode ? .checkmark : .none
                
        if let flagImage = UIImage(named: currency.currencyCode) {
            cell.imageView?.image = flagImage
            
            if indexPath.row == 0 {
                if self.imageSize == .zero {
                    self.imageSize = flagImage.size
                }
            } else {
                if indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 {
                    let scaledFlagImage = flagImage.imageWith(newSize: self.imageSize)
                    cell.imageView?.image = scaledFlagImage
                }
            }
            
        }
        
        let text = "\(currency.sign) \(currency.unit) = " + "\(CurrencyType.ILS.sign) \(currency.rate)"
        cell.textLabel?.text = text
        
        if let localized: String = Locale.current.localizedString(forCurrencyCode: currency.currencyCode) {
            cell.detailTextLabel?.text = localized
        } else {
            cell.detailTextLabel?.text = CurrencyType(rawValue: currency.currencyCode)?.localizedCountry
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard self.refferal.count > 0 else { return }
        
        let selectedCurrencyCode: String = self.currencies[indexPath.row].currencyCode
        self.sourceViewController.willChangeCurrency(selectedCurrencyCode: selectedCurrencyCode, refferal: self.refferal)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

/* extension FCCurrenciesTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
        let filtered = self.currencies.filter { (item: Currency) -> Bool in
            let isCurrencyCode: Bool = item.currencyCode.contains(searchText)
            let isCountry: Bool = item.country.contains(searchText)
            let isName: Bool = item.name.contains(searchText)
            return isCurrencyCode || isCountry || isName
        }
        
        print(filtered)
    }
    
} */
