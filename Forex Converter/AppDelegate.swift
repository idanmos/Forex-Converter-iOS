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
    
    let analyticsReporter: AnalyticsReporter = AnalyticsReporterBase()
    
    var isUsingCache: Bool {
        if let _ = self.responseData { return true }
        return false
    }
    
    class func sharedDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.removeCachedResponses(since: Date(timeIntervalSinceNow: -(60*60*24*365)))
        
        if let _ = UserDefaults.standard.string(forKey: Constants.kPreferredLanguageKey) {} else {
            UserDefaults.standard.setValue(Constants.kHebrewLanguageValue, forKey: Constants.kPreferredLanguageKey)
            UserDefaults.standard.synchronize()
        }
        
        if let savedData: Data = UserDefaults.standard.data(forKey: "data") {
            self.responseData = savedData
        }
        
        #if DEBUG
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        #endif
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FirebaseApp.configure()
        
        self.analyticsReporter.track(.appStart)
        
//        #if DEBUG
//        print(UIDevice.deviceDetails)
//
//        print("languageCode: " + (Locale.current.languageCode ?? ""))
//        print("variantCode: " + (Locale.current.variantCode ?? ""))
//
//        #endif
//
//        Analytics.logEvent("DeviceDetails", parameters: UIDevice.deviceDetails)
        
        ThemeManager.restore()
        
        print("Bundle.main.preferredLocalizations: \(Bundle.main.preferredLocalizations)")
        
        if let preferredLanguage: String = LocalizationHelper.requestPreferredLanguage() {
            print("preferredLanguage: \(preferredLanguage)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.analyticsReporter.track(.appClose)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.analyticsReporter.track(.appOpen)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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

}

