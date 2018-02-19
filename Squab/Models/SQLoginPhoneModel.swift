//
//  SQLoginPhoneModel.swift
//
//  Created by Chandrachudh on 21/10/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SQLoginPhoneModel:Decodable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQLoginPhoneModelDetailsKey: String = "Details"
  private let kSQLoginPhoneModelStatusKey: String = "Status"

  // MARK: Properties
  public var Details: String?
  public var Status: String?
    public var selectedMobileNumber:String?
    public var selectedCountryCode:String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    Details = json[kSQLoginPhoneModelDetailsKey].string
    Status = json[kSQLoginPhoneModelStatusKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = Details { dictionary[kSQLoginPhoneModelDetailsKey] = value }
    if let value = Status { dictionary[kSQLoginPhoneModelStatusKey] = value }
    return dictionary
  }
    
    class func getLoginModelWith(phoneNumber:String, countryCode:String)->SQLoginPhoneModel {
        let dict = [String:String]()
        let model = SQLoginPhoneModel(object: JSON(dict))
        model.selectedMobileNumber = phoneNumber
        model.selectedCountryCode = countryCode
        return  model
    }

    class func loginWith(mobileNumber:String, countryCode:String, returnBlock:@escaping returnBlock) {
        
        let connectingURL = "getstarted/sendsms?number=" + mobileNumber + "&code" + countryCode
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                returnBlock(nil, errorMessage)
            }
            else {
                if let data = response {
                    print("in string format = \(String.init(data: data as! Data, encoding: .utf8))")
                    do {
                        let responseModel = try JSONDecoder().decode(SQLoginPhoneModel.self, from: data as! Data)
                        responseModel.selectedMobileNumber = mobileNumber
                        responseModel.selectedCountryCode = countryCode
                        returnBlock(responseModel, nil)
                    }
                    catch let jsonError {
                        returnBlock(nil, jsonError.localizedDescription)
                    }
                }
            }
        }
    }
        
    func verifyMobile(otp:String, returnBlock:@escaping returnBlock) {
        if let details = Details {
            let connectingURL = "getstarted/verifyotp?session=" + details + "&otp=" + otp
            SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
                
                if let errorMessage = errorMessage {
                    returnBlock(nil, errorMessage)
                }
                else {
                    if let data = response {
                        do {
                            let responseModel = try JSONDecoder().decode(SQLoginPhoneModel.self, from: data as! Data)
                            returnBlock(responseModel, nil)
                        }
                        catch let jsonError {
                            returnBlock(nil, jsonError.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func registerUser(firstName:String, lastName:String, returnBlock:@escaping returnBlock) {
        guard let countryCode = selectedCountryCode else {
            return
        }
        
        guard let mobileNumber = selectedMobileNumber else {
            return
        }
        
        let deviceToken = SquabUserManager.sharedInstance.getDeviceToken()
        var code = countryCode
        if code.contains("+") {
            let rangeOfPlus = (code as NSString).range(of: "+")
            code = (code as NSString).replacingCharacters(in: rangeOfPlus, with: "")
        }
        
        var connectingURL = ""
        
        #if DEVELOPMENT
            let currentVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            connectingURL = "getstarted/regusers?mobileno=" + mobileNumber + "&code=" + code
            connectingURL = connectingURL + "&fname=" + firstName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            connectingURL = connectingURL + "&lname=" + lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            connectingURL = connectingURL + "&token=" + deviceToken + "&ostype=ios" + "&osversion="
            connectingURL = connectingURL + currentVersion + "&mobilemodel=" + modelName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        #else
            connectingURL = "getstarted/regusers?token=" + deviceToken + "&mobileno=" + mobileNumber + "&code=" + code
            connectingURL = connectingURL + "&fname=" + firstName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            connectingURL = connectingURL + "&lname=" + lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        #endif

        print("\n\n\n\n\n\n\nconnectingURL = ",connectingURL)
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                returnBlock(nil, errorMessage)
            }
            else {
                if let data = response {
                    do {
                        let responseModel = try JSONDecoder().decode(SQRequestSuccessStatusModel.self, from: data as! Data)
                        returnBlock(responseModel, nil)
                    }
                    catch let jsonError {
                        returnBlock(nil, jsonError.localizedDescription)
                    }
                }
            }
        }
        
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
