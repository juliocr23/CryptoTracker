//
//  PriceNotification.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/16/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import Foundation
import UserNotifications

class PriceNotification {
    
    static var delegate = UNUserNotificationCenter.current().delegate
    private static var notificationId = 0
    init(priceAlert: PriceAlert?) {
        createNotification()
    }
    
    private func createNotification(){
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let id =  String(PriceNotification.notificationId)
        PriceNotification.notificationId += 1
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Error in notification")
            }
        }
    }
    static func askForPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            print("granted: \(granted)")
        }
    }
}
