//
//  ApplicationCoordinator.swift
//  Forex Converter
//
//  Created by Idan Moshe on 04/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation
import UIKit

final class ApplicationCoordinator: Coordinator {
    
    // MARK: - Tab bar view controllers
    
    private lazy var ratesViewController: RatesViewController = {
        let viewController = RatesViewController(nibName: "RatesViewController", bundle: nil)
        return viewController
    }()
    
    private lazy var ratesConverterViewController: RatesConverterViewController = {
        let viewControlelr = RatesConverterViewController(nibName: "RatesConverterViewController", bundle: nil)
        return viewControlelr
    }()
    
    private lazy var feedTableViewController: FeedTableViewController = {
        let viewController = FeedTableViewController(nibName: "FeedTableViewController", bundle: nil)
        return viewController
    }()
    
    private lazy var rootViewController: UITabBarController = {
        return self.createTabBarController()
    }()
    
    private let window: UIWindow
    private var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        debugPrint("deallocating \(self)")
    }
    
    func start() {
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
}

// MARK: - General methods

private extension ApplicationCoordinator {
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [self.tabBarNavigationController(viewController: self.feedTableViewController, title: "חדשות כלכלה", imageName: "news"),
                                            self.tabBarNavigationController(viewController: self.ratesConverterViewController, title: "מחשבון המרה", imageName: "calculator"),
                                            self.tabBarNavigationController(viewController: self.ratesViewController, title: "שערי מט\"ח", imageName: "rates")]
        
        tabBarController.selectedIndex = tabBarController.viewControllers!.count-1
        
        return tabBarController
    }
    
    func tabBarNavigationController(viewController: UIViewController, title: String? = nil, imageName: String? = nil) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        
        if let image = UIImage(named: imageName ?? "") {
            navigationController.tabBarItem.image = image.imageResized(to: CGSize(width: 40, height: 40))
        }
        
        return navigationController
    }
        
}
