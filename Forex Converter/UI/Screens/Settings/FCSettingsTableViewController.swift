//
//  FCSettingsTableViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 20/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCSettingsTableViewController: ForexConverterTableViewController {
    
    @IBOutlet private weak var darkTextLabel: UILabel!
    @IBOutlet private weak var lightTextLabel: UILabel!
    @IBOutlet private weak var currentLanguageLabel: UILabel!
    @IBOutlet private weak var selectedLanguageLabel: UILabel!
    
    @IBOutlet private weak var darkContrainerView: UIView!
    @IBOutlet private weak var lightContrainerView: UIView!
    
    @IBOutlet private weak var darkSelectButton: UIButton!
    @IBOutlet private weak var lightSelectButton: UIButton!
    
    @IBOutlet private weak var darkCheckMarkView: UIView!
    @IBOutlet private weak var lightCheckMarkView: UIView!
    
    @IBOutlet private weak var darkCheckMarkLabel: UILabel!
    @IBOutlet private weak var lightCheckMarkLabel: UILabel!
    
    @IBOutlet private weak var mainCurrencyLabel: UILabel!
    @IBOutlet private weak var currentCurrencyLabel: UILabel!
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        view.backgroundColor = .clear
        return view
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
    
    private lazy var preferredLanguageFormatter: String = {
        let _preferredLanguage = self.preferredLanguage
        if preferredLanguage.contains(Language.hebrew.rawValue) {
            return "Hebrew".localized
        } else if preferredLanguage.contains(Language.english.rawValue) {
            return "English".localized
        } else if preferredLanguage.contains(Language.arabic.rawValue) {
            return "Arabic".localized
        } else {
            return ""
        }
    }()
    
    private let SegueToLanguages: String = "SegueToLanguages"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.selectedLanguageLabel.text = self.preferredLanguageFormatter
        
        self.darkTextLabel.text = "Dark".localized
        self.lightTextLabel.text = "Light".localized
        self.currentLanguageLabel.text = "Current Language".localized
        
        self.lightCheckMarkView.makeAsCircle()
        self.darkCheckMarkView.makeAsCircle()
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .light {
                self.lightCheckMarkLabel.isHidden = false
                self.darkCheckMarkLabel.isHidden = true
            } else if self.traitCollection.userInterfaceStyle == .dark {
                self.lightCheckMarkLabel.isHidden = true
                self.darkCheckMarkLabel.isHidden = false
            }
        } else {
            // Fallback on earlier versions
            self.darkContrainerView.isUserInteractionEnabled = false
            self.lightContrainerView.isUserInteractionEnabled = false
            
            self.lightCheckMarkLabel.isHidden = false
            self.darkCheckMarkLabel.isHidden = true
        }
        
        self.mainCurrencyLabel.text = "help_alert_1_title".localized
        self.currentCurrencyLabel.text = "help_alert_2_title".localized
    }
    
    /* private func getSelectedLanguage() -> String {
        if let languages = UserDefaults.standard.object(forKey: Constants.AppleLanguages) as? [String] {
            if let preferredLanguage: String = languages.first {
                if preferredLanguage.contains(Language.hebrew.rawValue) {
                    return "Hebrew".localized
                } else if preferredLanguage.contains(Language.english.rawValue) {
                    return "English".localized
                } else if preferredLanguage.contains(Language.arabic.rawValue) {
                    return "Arabic".localized
                }
            }
        }
        
    } */
    
    // MARK: - General methods
    
    private func showFirstHelpScreen() {
        let helpViewController = AlertHelpViewController.makeViewController()
        helpViewController.imageView.image = UIImage(named: "help_alert_1")
        helpViewController.textLabel.text = "help_alert_1_title".localized
        helpViewController.detailsLabel.text = "help_alert_1_details".localized
        helpViewController.closeButton.setTitle("help_alert_2_button".localized, for: .normal)
        
        helpViewController.setOnCloseEvent {
            //
        }
        
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    private func showSecondHelpScreen() {
        let helpViewController = AlertHelpViewController.makeViewController()
        helpViewController.imageView.image = UIImage(named: "help_alert_1")
        helpViewController.textLabel.text = "help_alert_2_title".localized
        helpViewController.detailsLabel.text = "help_alert_2_details".localized
        helpViewController.closeButton.setTitle("help_alert_2_button".localized, for: .normal)
        
        helpViewController.setOnCloseEvent {
            //
        }
        
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Look".localized
        } else if section == 1 {
            return "Language".localized
        } else if section == 2 {
            return "Help".localized
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Support_iOS_13_And_Above".localized
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        return self.footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.footerView.frame.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegue(withIdentifier: SegueToLanguages, sender: nil)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                self.showFirstHelpScreen()
            } else if indexPath.row == 1 {
                self.showSecondHelpScreen()
            }
        }
    }
    
    @IBAction private func onChangeToDarkStylePress(_ sender: Any) {
        ThemeManager.applyStyle(.dark)
        
        self.lightCheckMarkLabel.isHidden = true
        self.darkCheckMarkLabel.isHidden = false
        
        UserDefaults.standard.set(ThemeManagerStyle.dark.rawValue, forKey: "ThemeManagerStyle")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction private func onChangeToLightStylePress(_ sender: Any) {
        ThemeManager.applyStyle(.light)
        
        self.lightCheckMarkLabel.isHidden = false
        self.darkCheckMarkLabel.isHidden = true
        
        UserDefaults.standard.set(ThemeManagerStyle.light.rawValue, forKey: "ThemeManagerStyle")
        UserDefaults.standard.synchronize()
    }

}
