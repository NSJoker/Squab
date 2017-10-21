//
//  SquabUserManager.swift
//  Squab
//
//  Created by Chandrachudh on 21/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

let REGISTERED_PHONE_KEY = "com.squab.registered_phone_key"

class SquabUserManager: NSObject {
    
    var registeredPhone:String = ""

    class var sharedInstance: SquabUserManager {
        struct Static {
            static let instance: SquabUserManager = SquabUserManager()
        }
        
        Static.instance.getRegiteredPhone()
        
        return Static.instance
    }
    
    private func getRegiteredPhone() {
        let userDefaults = UserDefaults.standard
        if let phone = userDefaults.object(forKey: REGISTERED_PHONE_KEY) {
            registeredPhone = phone as! String
        }
    }
    
    func saveNewRegisteredPhone(phone:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(phone, forKey: REGISTERED_PHONE_KEY)
        registeredPhone = phone
    }
}
