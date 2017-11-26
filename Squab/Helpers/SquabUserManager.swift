//
//  SquabUserManager.swift
//  Squab
//
//  Created by Chandrachudh on 21/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

let LOGIN_USER_PHONE_NUMBER = "com.squab.login_user_phone_number"
let LOGIN_USER_COUNTRY_CODE = "com.squab.login_user_country_code"
let LOGIN_COMPLETED_KEY = "com.squab.login_completed"
let DEVICE_TOKEN_KEY = "com.squab.device_token"

enum LoginType {
    case notLoggedIn
    case loggedInButNoUserDetails
    case loggedIn
}

class SquabUserManager: NSObject {
    
    var registeredPhone:String = ""
    fileprivate var currentLogintype = LoginType.notLoggedIn

    class var sharedInstance: SquabUserManager {
        struct Static {
            static let instance: SquabUserManager = SquabUserManager()
        }
        
        Static.instance.getUserLoginState()
        
        return Static.instance
    }
    
    func saveLoginModel(loginModel:SQLoginPhoneModel) {
        let userDefaults = UserDefaults.standard
        
        if let phoneNumber = loginModel.selectedMobileNumber {
            userDefaults.set(phoneNumber, forKey: LOGIN_USER_PHONE_NUMBER)
        }
        if let code = loginModel.selectedCountryCode {
            userDefaults.set(code, forKey: LOGIN_USER_COUNTRY_CODE)
        }
        currentLogintype = .loggedInButNoUserDetails
    }
    
    fileprivate func getUserLoginState() {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: LOGIN_USER_PHONE_NUMBER) != nil {
            currentLogintype = .loggedInButNoUserDetails
            
            if userDefaults.object(forKey: LOGIN_COMPLETED_KEY) != nil {
                currentLogintype = .loggedIn
            }
        }
        else {
            currentLogintype = .notLoggedIn
        }
    }
    
    func markLoginCompleted() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("completed", forKey: LOGIN_COMPLETED_KEY)
    }
    
    func getCurrentUserLoggedInState()->LoginType {
        return currentLogintype
    }
    
    func getLoginResponseModel()->SQLoginPhoneModel {
        let userDefaults = UserDefaults.standard
        
        let phoneNumber = userDefaults.object(forKey: LOGIN_USER_PHONE_NUMBER)
        let countryCode = userDefaults.object(forKey: LOGIN_USER_COUNTRY_CODE)
        let loginModel = SQLoginPhoneModel.getLoginModelWith(phoneNumber: phoneNumber as! String, countryCode: countryCode as! String)
        
        return loginModel
    }
    
    func getSavedMobileNumber()->String {
        return getLoginResponseModel().selectedMobileNumber ?? ""
    }
    
    func saveDeviceToken(deviceToken:String) {
        UserDefaults.standard.set(deviceToken, forKey: DEVICE_TOKEN_KEY)
    }
    
    func getDeviceToken()->String {
        if let token = UserDefaults.standard.object(forKey: DEVICE_TOKEN_KEY) {
            return token as! String
        }
        return ""
    }
}
