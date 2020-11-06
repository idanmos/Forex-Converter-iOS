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
    
    var applicationCoordinator: ApplicationCoordinator!
    
    var isUsingCache: Bool {
        if let _ = self.responseData { return true }
        return false
    }

    class func sharedDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.clearCache()
        self.load3rdPartyLibraries()
        
        /* if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let viewControllers: [UIViewController] = tabBarController.viewControllers {
                tabBarController.selectedIndex = viewControllers.count-1
            }
        } */
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.applicationCoordinator = ApplicationCoordinator(window: self.window!)
        self.applicationCoordinator.start()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
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
    
    // MARK: - General Methods
    
    private func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.removeCachedResponses(since: Date(timeIntervalSinceNow: -(60*60*24*365)))
    }
    
    private func load3rdPartyLibraries() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
    }

}
