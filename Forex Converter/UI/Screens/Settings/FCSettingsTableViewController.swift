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
    
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings".localized
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.selectedLanguageLabel.text = self.getSelectedLanguage()
        
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
    }
    
    private func getSelectedLanguage() -> String {
        if let selectedLanguage = UserDefaults.standard.value(forKey: Constants.kPreferredLanguageKey) as? String {
            if selectedLanguage == Constants.kHebrewLanguageValue {
                return "Hebrew".localized
            } else if selectedLanguage == Constants.kEnglishLanguageValue {
                return "English".localized
            } else if selectedLanguage == Constants.kArabicLanguageValue {
                return "Arabic".localized
            }
        }
        return ""
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Look".localized
        } else if section == 1 {
            return "Language".localized
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
