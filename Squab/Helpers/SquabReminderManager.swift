//
//  SquabReminderManager.swift
//  Squab
//
//  Created by Chandrachudh on 01/01/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import UIKit
import UserNotifications

class SquabReminderManager: NSObject {
    class var sharedInstance: SquabReminderManager {
        struct Static {
            static let instance: SquabReminderManager = SquabReminderManager()
        }
        return Static.instance
    }
    
    func addNewReminder() {
        
    }
    
    func refreshReminders() {
        
    }
    
    func getAllReminders() {
        
    }
    
    func hasReminderSetFor(docID:String) {
        
    }
    
    func resetAllLocalNotifications() {
        
    }
}

extension SquabReminderManager {
    func isPushNotificationEnabled()->Bool {
        guard let settings = UIApplication.shared.currentUserNotificationSettings
            else {
                return false
        }
        
        return UIApplication.shared.isRegisteredForRemoteNotifications
            && !settings.types.isEmpty
    }
    
    func verifyAndSendLocalNotification() {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                switch settings.authorizationStatus {
                case .authorized:
                    self.sendLocalNotification()
                    break
                default:
                    break
                }
            })
        } else {
            // Fallback on earlier versions
            if self.isPushNotificationEnabled() {
                self.sendLocalNotification()
            }
        }
    }
    
    func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default()
        
        let date = Date(timeIntervalSinceNow: 30)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error local notification = ",error)
            }
        })
    }
}
