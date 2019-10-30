//
//  AppDelegate.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var responseData: Data?
    
    /// The analytics reporter to inject into classes.
    /* var analyticsReporter: AnalyticsReporter {
      fatalError("Subclasses must override and provide an analytics reporter instance!")
    } */
    
    let analyticsReporter: AnalyticsReporter = AnalyticsReporterWrapper()
    
    var isUsingCache: Bool {
        if let _ = self.responseData { return true }
        return false
    }

    class func sharedDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.loadPreferences()
        self.clearCache()
        self.load3rdPartyLibraries()
        self.registerObservers()
        self.logDebugDetails()
                
        self.analyticsReporter.track(.applicationDidFinishLaunchingWithOptions)
        self.analyticsReporter.track(.deviceDetails(UIDevice.deviceDetails))
        
//        print("Bundle.main.preferredLocalizations: \(Bundle.main.preferredLocalizations)")
//
//        if let preferredLanguage: String = LocalizationHelper.requestPreferredLanguage() {
//            print("preferredLanguage: \(preferredLanguage)")
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.analyticsReporter.track(.applicationWillResignActive)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.analyticsReporter.track(.applicationDidEnterBackground)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.analyticsReporter.track(.applicationWillEnterForeground)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.analyticsReporter.track(.applicationDidBecomeActive)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
        self.analyticsReporter.track(.applicationWillTerminate)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Forex_Converter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - General Methods
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDidTakeScreenshotNotification(note:)),
                                               name: UIApplication.userDidTakeScreenshotNotification,
                                               object: nil)
    }
    
    @objc private func userDidTakeScreenshotNotification(note: NSNotification) {
        self.analyticsReporter.track(.userDidTakeScreenshotNotification)
    }
    
    private func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.removeCachedResponses(since: Date(timeIntervalSinceNow: -(60*60*24*365)))
    }
    
    private func load3rdPartyLibraries() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
    }
    
    private func loadPreferences() {
        if let savedData: Data = UserDefaults.standard.data(forKey: "data") {
            self.responseData = savedData
        }
        
        ThemeManager.restore()
    }
    
    private func logDebugDetails() {
        #if DEBUG
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        print("UIDevice.deviceDetails: \(UIDevice.deviceDetails)")

        print("Locale.current.languageCode: " + (Locale.current.languageCode ?? ""))
        print("Locale.current.variantCode: " + (Locale.current.variantCode ?? ""))
        #endif
    }

}

