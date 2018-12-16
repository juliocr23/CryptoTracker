//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 11/30/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

//TODO Notifications Thats the last thing you did background fetch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        PriceNotification.delegate = self
        PriceNotification.askForPermission()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let  temp: UIViewController? = mainStoryboard.instantiateViewController(withIdentifier: "TabBar")
     
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = temp
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
      // self.saveContext()
    }
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Do background work here
        
        //Use for updating
        
      /* Cryptocurrency.list.removeAll(keepingCapacity: true)
       SearchController.loadImages()
       CryptoCompare.downloadPrices(completion: {
           print("Data has been completed")
        
        if  let VC = self.window?.rootViewController as? SearchController {
            print("Hello bitche!")
        }
           completionHandler(.newData)
        })*/
    }

    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptoTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

}

