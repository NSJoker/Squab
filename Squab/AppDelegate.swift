//
//  AppDelegate.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldShowPushnotificationPermission = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        checkForPushNotificationPermission()
        
        #if DEVELOPMENT
            SquabDataCenter.sharedInstance.domain = "http://squab.avartaka.com:8083/"
        #else
            SquabDataCenter.sharedInstance.domain = "http://squab.avartaka.com:9083/"
        #endif
                
        setUpRootViewController()
        return true
    }
    
    func setUpRootViewController() {
        var rootController:UIViewController = SQLandingPageController()
        
        switch SquabUserManager.sharedInstance.getCurrentUserLoggedInState() {
        case .loggedInButNoUserDetails:
            let nextController = SQUserDetailsEntryController()
            nextController.loginResponseModel = SquabUserManager.sharedInstance.getLoginResponseModel()
            rootController = nextController
            break
        case .loggedIn:
            rootController = SQBoardsPageController()
            break
        default:
            break
        }
        
        let navigationController = UINavigationController.init(rootViewController: rootController)
        navigationController.isNavigationBarHidden = true
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
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
    }
}

extension AppDelegate {
    func checkForPushNotificationPermission() {
        shouldShowPushnotificationPermission = false
        let deviceToken = SquabUserManager.sharedInstance.getDeviceToken()
        if deviceToken.characters.count == 0 {
            shouldShowPushnotificationPermission = true
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notification permission was not already granted
                    self.shouldShowPushnotificationPermission = true
                }
            })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications == false {
                shouldShowPushnotificationPermission = true
            }
        }
    }
    
    func getPushNotificationPermission() {
        let application = UIApplication.shared
        //push Notification
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                if granted {
                }
                else {
                }
            }
            application.registerForRemoteNotifications()
        } else {
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let pushNotificationSettings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
            
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var pushToken = String(format: "%@", deviceToken as CVarArg)
        pushToken = pushToken.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        pushToken = pushToken.replacingOccurrences(of: " ", with: "")
        print("DEVICE TOKEN ====== \(pushToken)")
        SquabUserManager.sharedInstance.saveDeviceToken(deviceToken: pushToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SquabUserManager.sharedInstance.saveDeviceToken(deviceToken: "")
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Just received remote notification: ",userInfo)
    }
}

