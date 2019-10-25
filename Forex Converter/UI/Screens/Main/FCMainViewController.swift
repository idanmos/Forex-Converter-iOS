//
//  FCMainViewController.swift
//  Forex Converter
//
//  Created by Idan Moshe on 06/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FCMainViewController: ForexConverterViewController {
    
    // MARK: - Outlets - Main
    
    @IBOutlet private weak var displayContainerView: UIView!
    @IBOutlet private weak var keypadContainerView: UIView!
    @IBOutlet private weak var bannerView: GADBannerView!
    
    // MARK: - Outlets - Display
    
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var displayCurrencyCodeLabel: UILabel!
    @IBOutlet weak var displayDescriptionLabel: UILabel!
    
    @IBOutlet weak var secondAmountTextField: UITextField!
    @IBOutlet weak var secondCurrencyCodeLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!
    
    @IBOutlet weak var thirdAmountTextField: UITextField!
    @IBOutlet weak var thirdCurrencyCodeLabel: UILabel!
    @IBOutlet weak var thirdDescriptionLabel: UILabel!
    
    @IBOutlet weak var asOfDateLabel: UILabel!
    
    @IBOutlet private weak var secondChangeCurrencyButton: UIButton!
    @IBOutlet private weak var thirdChangeCurrencyButton: UIButton!
    
    // MARK: - Outlets - Keypad
    
    @IBOutlet weak var zeroNumberButton: UIButton!
    @IBOutlet weak var oneNumberButton: UIButton!
    @IBOutlet private weak var twoNumberButton: UIButton!
    @IBOutlet private weak var threeNumberButton: UIButton!
    @IBOutlet private weak var fourNumberButton: UIButton!
    @IBOutlet private weak var fiveNumberButton: UIButton!
    @IBOutlet private weak var sixNumberButton: UIButton!
    @IBOutlet private weak var sevenNumberButton: UIButton!
    @IBOutlet private weak var eightNumberButton: UIButton!
    @IBOutlet private weak var nineNumberButton: UIButton!
    @IBOutlet private weak var decimalNumberButton: UIButton!
    
    @IBOutlet private weak var clearAllNumberButton: UIButton!
    @IBOutlet private weak var dropLastNumberButton: UIButton!
    
    @IBOutlet private weak var settingsButton: UIButton!
    
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var equalButton: UIButton!
    
    // MARK: - Declarations
    
    private let SegueToCurrencies = "SegueToCurrencies"
    private let SegueToSettings = "SegueToSettings"
    
    private var displayLogic = FCDisplayLogic()
    private var keypadLogic = FCKeypadLogic()
    
    private lazy var presenterLogic: FCMainViewControllerLogic = {
        var presenter = FCMainViewControllerLogic()
        presenter.delegate = self
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        LoaderView.show()
        
        let settingsBarButton = UIBarButtonItem(title: "⚙︎",
                                                style: .plain,
                                                target: self,
                                                action: #selector(self.onSettingsPress(_:)))
        
        settingsBarButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 35)],
                                                 for: .normal)
        
        let listBarButton = UIBarButtonItem(barButtonSystemItem: .search,
                                            target: self,
                                            action: #selector(self.showCurrenciesListScreen))
        
        self.navigationItem.setRightBarButtonItems([settingsBarButton, listBarButton], animated: true)
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.onMakeSnapshotPress(_:)))
        
        self.navigationItem.setLeftBarButton(shareButton, animated: true)
        
        self.displayLogic.delegate = self
        self.keypadLogic.delegate = self
        
        self.setupKeypadUI()

        self.presenterLogic.fetchCurrencies()
        
        self.bannerView.adUnitID = Constants.GoogleAdMob_AdUnitId_Banner
        self.bannerView.rootViewController = self
        self.bannerView.isAutoloadEnabled = true
        
        let att = NSMutableAttributedString(string: "↓↑");
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: 1))
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 1, length: 1))
        self.secondChangeCurrencyButton.setAttributedTitle(att, for: .normal)
        self.thirdChangeCurrencyButton.setAttributedTitle(att, for: .normal)
        
        if UserDefaults.standard.bool(forKey: "alert_help") == false {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showFirstHelpScreen()
            }
        }
       
    }
    
    private func showFirstHelpScreen() {
        let helpViewController = AlertHelpViewController.makeViewController()
        helpViewController.imageView.image = UIImage(named: "help_alert_1")
        helpViewController.textLabel.text = "help_alert_1_title".localized
        helpViewController.detailsLabel.text = "help_alert_1_details".localized
        helpViewController.closeButton.setTitle("help_alert_1_button".localized, for: .normal)
        
        helpViewController.setOnCloseEvent {
            // Show next help view controller
            self.showSecondHelpScreen()
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
            // Save key in order not to show the screens again
            UserDefaults.standard.set(true, forKey: "alert_help")
            UserDefaults.standard.synchronize()
        }
        
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueToCurrencies {
            if let currenciesTableViewController = segue.destination as? FCCurrenciesTableViewController {
                currenciesTableViewController.sourceViewController = self
                
                if let referral = sender as? String {
                    currenciesTableViewController.refferal = referral
                    
                    if referral == "2" {
                        currenciesTableViewController.previousCurrencyCode = self.displayLogic.secondCurrency.currencyCode
                    } else if referral == "3" {
                        currenciesTableViewController.previousCurrencyCode = self.displayLogic.thirdCurrency.currencyCode
                    }
                }
            }
        } else if segue.identifier == SegueToSettings {
            //
        }
    }
    
    // MARK: - General methods
    
    @objc private func onSettingsPress(_ sender: Any) {
        self.performSegue(withIdentifier: SegueToSettings, sender: sender)
    }
    
    private func setupDisplayUI() {
        self.displayTextField.text = ""
        self.displayCurrencyCodeLabel.text = ""
        self.displayDescriptionLabel.text = ""
        
        self.secondAmountTextField.text = ""
        self.secondCurrencyCodeLabel.text = ""
        self.secondDescriptionLabel.text = ""
        
        self.thirdAmountTextField.text = ""
        self.thirdCurrencyCodeLabel.text = ""
        self.thirdDescriptionLabel.text = ""
        
        self.asOfDateLabel.text = ""
    }
    
    private func setupKeypadUI() {
        self.zeroNumberButton.tag = CalculatorKey.zero.rawValue
        self.oneNumberButton.tag = CalculatorKey.one.rawValue
        self.twoNumberButton.tag = CalculatorKey.two.rawValue
        self.threeNumberButton.tag = CalculatorKey.three.rawValue
        self.fourNumberButton.tag = CalculatorKey.four.rawValue
        self.fiveNumberButton.tag = CalculatorKey.five.rawValue
        self.sixNumberButton.tag = CalculatorKey.six.rawValue
        self.sevenNumberButton.tag = CalculatorKey.seven.rawValue
        self.eightNumberButton.tag = CalculatorKey.eight.rawValue
        self.nineNumberButton.tag = CalculatorKey.nine.rawValue
        self.decimalNumberButton.tag = CalculatorKey.decimal.rawValue
        self.clearAllNumberButton.tag = CalculatorKey.clear.rawValue
        self.dropLastNumberButton.tag = CalculatorKey.delete.rawValue
        
        self.plusButton.tag = CalculatorKey.add.rawValue
        self.minusButton.tag = CalculatorKey.subtract.rawValue
        self.equalButton.tag = CalculatorKey.equal.rawValue
        
        self.clearAllNumberButton.setTitle("ClearAll".localized, for: .normal)
        self.dropLastNumberButton.setTitle("Delete".localized, for: .normal)
    }
    
    private func handleResponseData(_ responseData: Data) {
        let xmlParser = FCXMLParser(data: responseData)
        
        xmlParser.completionHandler =  {
            // Finish parsing
            FCDataSourceManager.shared().addIsraeliNewShekel()
            self.setupData()
        }
        
        xmlParser.parse()
    }
    
    private func setupData() {
        self.displayLogic.setupData()
        self.keypadLogic.onButtonPressed(senderTag: self.zeroNumberButton.tag)
    }
    
    func willChangeCurrency(selectedCurrencyCode currencyCode: String, refferal: String) {
        let selectedCurrency = FCDataSourceManager.shared().currencies.first(where: { $0.currencyCode == currencyCode })
        if let selectedCurrency = selectedCurrency {
            if refferal == "\(Constants.kSecondCurrencyLine)" {
                self.displayLogic.changeCurrencies(newSecondCurrency: selectedCurrency)
            } else if refferal == "\(Constants.kThirdCurrencyLine)" {
                self.displayLogic.changeCurrencies(newThirdCurrency: selectedCurrency)
            }
        }
    }
    
    @objc private func showCurrenciesListScreen() {
        self.performSegue(withIdentifier: SegueToCurrencies, sender: nil)
    }
    
    // MARK: - Actions
    
    // MARK: Display
    
    @IBAction private func onChangeSecondCurrenct(_ sender: Any) {
        self.analyticsReporter.track(.displayChangeSecond)
        self.performSegue(withIdentifier: SegueToCurrencies, sender: "\(Constants.kSecondCurrencyLine)")
    }
    
    @IBAction private func onChangeThirdCurrenct(_ sender: Any) {
        self.analyticsReporter.track(.displayChangeThird)
        self.performSegue(withIdentifier: SegueToCurrencies, sender: "\(Constants.kThirdCurrencyLine)")
    }
    
    @IBAction private func onActivateFirstCurrency(_ sender: Any) {
        self.analyticsReporter.track(.displaySelectFirst)
        self.displayLogic.activeLine = Constants.kFirstCurrencyLine
    }
    
    @IBAction private func onActivateSecondCurrency(_ sender: Any) {
        self.analyticsReporter.track(.displaySelectSecond)
        self.displayLogic.activeLine = Constants.kSecondCurrencyLine
    }
    
    @IBAction private func onActivatethirdCurrency(_ sender: Any) {
        self.analyticsReporter.track(.displaySelectThird)
        self.displayLogic.activeLine = Constants.kThirdCurrencyLine
    }
    
    // MARK: Keypad
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        func onButtonPressed(senderTag: Int) {
            switch (senderTag) {
            case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
                self.analyticsReporter.track(.currenciesListSelectNumber)
            case CalculatorKey.decimal.rawValue:
                self.analyticsReporter.track(.currenciesListSelectDot)
            case CalculatorKey.clear.rawValue:
                self.analyticsReporter.track(.currenciesListClearAll)
            case CalculatorKey.delete.rawValue:
                self.analyticsReporter.track(.currenciesListDropLast)
            default:
                break
            }
        }
        
        self.keypadLogic.onButtonPressed(senderTag: sender.tag)
    }
    
    @IBAction func onMakeSnapshotPress(_ sender: Any) {
        self.analyticsReporter.track(.currenciesListShare)
        
        if let snapshotImage: UIImage = self.view.makeSnapshot() {
            let shareController = UIActivityViewController(activityItems: [snapshotImage], applicationActivities: nil)
            
            // When presenting on iPad the ViewController presented as popOver therefore we need a source view
            if let _ = shareController.popoverPresentationController {
                shareController.popoverPresentationController?.sourceView = self.view
            }
            
            self.present(shareController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - FCMainViewControllerDelegate

extension FCMainViewController: FCMainViewControllerDelegate {
    
    
    
    func mainViewControllerLogicDidSuccess(_ mainViewControllerLogic: FCMainViewControllerLogic) {        
        self.displayLogic.setupData()
        self.displayLogic.activeLine = Constants.kFirstCurrencyLine
        self.keypadLogic.onButtonPressed(senderTag: self.zeroNumberButton.tag)
    }
    
    func mainViewControllerLogicDidFail(_ mainViewControllerLogic: FCMainViewControllerLogic,
                                        didFailWithError error: Error) {
        self.displayContainerView.isUserInteractionEnabled = false
        self.keypadContainerView.isUserInteractionEnabled = false
        
        let errorController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(errorController, animated: true, completion: nil)
    }
    
}

// MARK: - FCDisplayLogicDelegate

extension FCMainViewController: FCDisplayLogicDelegate {
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeActiveColorAtIndex currencyIndex: Int) {
        self.displayTextField.textColor = currencyIndex == Constants.kFirstCurrencyLine ? Constants.activeTextColor : Constants.inactiveTextColor
        self.secondAmountTextField.textColor = currencyIndex == Constants.kSecondCurrencyLine ? Constants.activeTextColor : Constants.inactiveTextColor
        self.thirdAmountTextField.textColor = currencyIndex == Constants.kThirdCurrencyLine ? Constants.activeTextColor : Constants.inactiveTextColor
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeAsOfDate asOfDate: String) {
        self.asOfDateLabel.text = asOfDate
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstTextField firstTextField: String) {
        self.displayTextField.text = firstTextField
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondTextField secondTextField: String) {
        self.secondAmountTextField.text = secondTextField
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdTextField thirdTextField: String) {
        self.thirdAmountTextField.text = thirdTextField
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstDescription firstDescription: String) {
        self.displayDescriptionLabel.text = firstDescription
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondDescription secondDescription: String) {
        self.secondDescriptionLabel.text = secondDescription
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdDescription thirdDescription: String) {
        self.thirdDescriptionLabel.text = thirdDescription
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeFirstCurrencyCode firstCurrencyCode: String) {
        self.displayCurrencyCodeLabel.text = firstCurrencyCode
    }

    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeSecondCurrencyCode secondCurrencyCode: String) {
        self.secondCurrencyCodeLabel.text = secondCurrencyCode
    }
    
    func displayLogic(_ displayLogic: FCDisplayLogic, didChangeThirdCurrencyCode thirdCurrencyCode: String) {
        self.thirdCurrencyCodeLabel.text = thirdCurrencyCode
    }
    
}

// MARK: - FCKeypadLogicDelegate

extension FCMainViewController: FCKeypadLogicDelegate {
    
    func keypadLogic(_ keypadLogic: FCKeypadLogic, didChangeValue value: String) {
        self.displayLogic.didChangeValue(value: value)
    }
    
}
