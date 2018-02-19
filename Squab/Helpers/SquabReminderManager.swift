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
    
    private let ALL_REMINDERS_KEY = "co.squab.all_reminders"
    var allReminders = [SQReminder]()
    
    class var sharedInstance: SquabReminderManager {
        struct Static {
            static let instance: SquabReminderManager = SquabReminderManager()
        }
        if Static.instance.allReminders.count == 0 {
            Static.instance.allReminders = Static.instance.getAllReminders()
        }
        return Static.instance
    }
    
    func addNewReminder(searchResult:SQSearchResults, date:Date) {
        let reminder = SQReminder()
        reminder.reminderDate = date
        reminder.reminderSearchResult = searchResult
        
        verifyAndSendLocalNotification(title: "You have a new reminder", body: searchResult.title!, userInfo: searchResult.dictionaryRepresentation(), date: date, identifier: searchResult.title! + "/" + searchResult.docid!)
        
        allReminders.append(reminder)
        saveAllReminders()
    }
    
    private func getAllReminders()->[SQReminder] {
        var reminders = [SQReminder]()
        
        let array = UserDefaults.standard.object(forKey: ALL_REMINDERS_KEY)
        
        if array != nil {
            let reminderDictsArray = array as! [[String:Any]]
            
            for dict in reminderDictsArray {
                let reminder = SQReminder.getReminderFromDict(dict: dict)
                reminders.append(reminder)
            }
        }
        
        return reminders
    }
    
    func hasReminderSetFor(docID:String)->Bool {
        for reminder in allReminders {
            if reminder.reminderSearchResult?.docid == docID {
                return true
            }
        }
        return false
    }
    
    func resetAllLocalNotifications() {
        
        for reminder in allReminders {
            verifyAndSendLocalNotification(title: "You have a new reminder", body: (reminder.reminderSearchResult?.title)!, userInfo: (reminder.reminderSearchResult?.dictionaryRepresentation())!, date: reminder.reminderDate!, identifier: (reminder.reminderSearchResult?.title)! + "/" + (reminder.reminderSearchResult?.docid)!)
        }
        
    }
    
    func removeReminder(docID:String) {
        var index = -1
        for i in 0..<allReminders.count {
            let reminder = allReminders[i]
            
            if reminder.reminderSearchResult?.docid == docID {
                index = i
                break
            }
        }
        
        if index != -1 {
            let searchResult = allReminders[index].reminderSearchResult
            allReminders.remove(at: index)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [(searchResult?.title!)! + "/" + (searchResult?.docid!)!])
            saveAllReminders()
        }
    }
    
    private func saveAllReminders() {
        var array = [[String:Any]]()
        
        for reminder in allReminders {
            var dict = reminder.dictionaryRepresentation()
            array.append(dict)
        }
        
        UserDefaults.standard.set(array, forKey: ALL_REMINDERS_KEY)
    }
    
    func removeAncientReminders() {
        var remindersToRemove = [SQReminder]()
        for reminder in allReminders {
            if (reminder.reminderDate?.timeIntervalSince1970)! < Date().timeIntervalSince1970 {
                remindersToRemove.append(reminder)
            }
        }
        
        for reminder in remindersToRemove {
            removeReminder(docID: (reminder.reminderSearchResult?.docid)!)
        }
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
    
    func verifyAndSendLocalNotification(title:String, body:String, userInfo:[String:Any], date:Date, identifier:String) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                switch settings.authorizationStatus {
                case .authorized:
                    self.sendLocalNotification(title: title, body: body, userInfo: userInfo, date: date, identifier: identifier)
                    break
                default:
                    break
                }
            })
        } else {
            // Fallback on earlier versions
            if self.isPushNotificationEnabled() {
                self.sendLocalNotification(title: title, body: body, userInfo: userInfo, date: date, identifier: identifier)
            }
        }
    }
    
    func sendLocalNotification(title:String, body:String, userInfo:[String:Any], date:Date, identifier:String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = userInfo
        content.sound = UNNotificationSound.default()
        
        let date = date
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error local notification = ",error)
            }
        })
    }
}
