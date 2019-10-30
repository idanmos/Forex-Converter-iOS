//
//  FCLanguageTableViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 21/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

struct SettingsLanguage {
    var code: Localization = .he_IL
    var localized: String = ""
}

class FCLanguageTableViewController: ForexConverterTableViewController {
    
    private lazy var languages: [SettingsLanguage] = {
        var langs: [SettingsLanguage] = []
        langs.append(SettingsLanguage(code: .he_IL, localized: "Hebrew".localized))
        langs.append(SettingsLanguage(code: .en_US, localized: "English".localized))
        langs.append(SettingsLanguage(code: .ar, localized: "Arabic".localized))
        return langs
    }()
    
    private lazy var preferredLanguage: String = {
        if let preferredLanguages = UserDefaults.standard.object(forKey: Constants.AppleLanguages) as? [String] {
            if let preferredLanguage: String = preferredLanguages.first {
                let languageComponents = NSLocale.components(fromLocaleIdentifier: preferredLanguage)
                if let languageCode = languageComponents[NSLocale.Key.languageCode.rawValue] {
                    return languageCode
                }
            }
        }
        return "en_US"
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Language".localized
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - General Methods
    
    /* private func getCurrentLanguageCode() -> String? {
        let preferredLanguage = NSLocale.preferredLanguages.first ?? "en_US"
        let languageComponents = NSLocale.components(fromLocaleIdentifier: preferredLanguage)
        let languageCode = languageComponents[NSLocale.Key.languageCode.rawValue]
        return languageCode
    } */
    
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
        
        let language = self.languages[indexPath.row].code.rawValue
        if language.contains(self.preferredLanguage) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let changeLanguageEvent = AnalyticsEvent.currenciesListChangeLanguage(self.languages[indexPath.row].code.rawValue)
        self.analyticsReporter.track(changeLanguageEvent)
        
        let selectedLangCode: String = self.languages[indexPath.row].code.rawValue
        UserDefaults.standard.setValue([selectedLangCode], forKey: Constants.AppleLanguages)
        UserDefaults.standard.synchronize()
                
        for viewController: UIViewController in self.navigationController!.viewControllers {
            viewController.viewDidLoad()
        }
        
        self.navigationController!.popToRootViewController(animated: true)
    }

}
