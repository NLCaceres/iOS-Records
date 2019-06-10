//
//  AppDelegate.swift
//  InfectionControl
//
//  Created by Nick Caceres on 3/29/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBar: UITabBarController?
    
//    // Prevents completion handler issue (they're not supported in background downloads)
//    var backgroundSessionCompletionHandler: (() -> Void)?
//    func application(_ application: UIApplication, handleEventsForBackgroundURLSession
//        identifier: String, completionHandler: @escaping () -> Void) {
//        backgroundSessionCompletionHandler = completionHandler
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.set(UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0), forKey: "backgroundColor")  // USC Light Gray
        UserDefaults.standard.set(UIColor(red:1.00, green: 0.80, blue: 0.00, alpha: 1.0), forKey: "headerBackgroundColor") // USC Gold
        UserDefaults.standard.set(UIColor(red:0.60, green:0.00, blue:0.00, alpha:1.0), forKey: "headerTextColor") // USC Red
        configureTabBar()
        configureNavBar()
        return true
    }
    
    func configureTabBar() {
        tabBar = self.window?.rootViewController as? UITabBarController
        if let tabBar = tabBar {
            tabBar.selectedIndex = 1
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x990000)], for: .selected)
    }
    func configureNavBar() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor =  UIColor(rgb: 0x990000)
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFFCC00)]
        // Can add a drop shadow here somehow but maybe it's an iOS12 thing to not have a divide anymore
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        let container = NSPersistentContainer(name: "InfectionControl")
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

