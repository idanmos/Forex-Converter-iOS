//
//  FCLanguageTableViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 21/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

struct SettingsLanguage {
    var code: String = ""
    var localized: String = ""
}

class FCLanguageTableViewController: ForexConverterTableViewController {
    
    private lazy var languages: [SettingsLanguage] = {
        var langs: [SettingsLanguage] = []
        langs.append(SettingsLanguage(code: Constants.kHebrewLanguageValue, localized: "Hebrew".localized))
        langs.append(SettingsLanguage(code: Constants.kEnglishLanguageValue, localized: "English".localized))
        langs.append(SettingsLanguage(code: Constants.kArabicLanguageValue, localized: "Arabic".localized))
        return langs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Language".localized
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.languages[indexPath.row].localized
        cell.accessoryType = .none
        
        if let savedLanguage = UserDefaults.standard.string(forKey: Constants.kPreferredLanguageKey) {
            if savedLanguage == self.languages[indexPath.row].code {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let changeLanguageEvent = AnalyticsEvent.currenciesListChangeLanguage(self.languages[indexPath.row].code)
        self.analyticsReporter.track(changeLanguageEvent)
        
        UserDefaults.standard.setValue(self.languages[indexPath.row].code, forKey: Constants.kPreferredLanguageKey)
        UserDefaults.standard.synchronize()
        
        self.tableView.reloadData()
    }

}
