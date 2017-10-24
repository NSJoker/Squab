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
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shoulShowLoadingIndicator: true) { (response, errorMessage) in
            
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
            SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shoulShowLoadingIndicator: true) { (response, errorMessage) in
                
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
        
        let deviceToken = "weibiefbiwebf"
        var code = countryCode
        if code.contains("+") {
            let rangeOfPlus = (code as NSString).range(of: "+")
            code = (code as NSString).replacingCharacters(in: rangeOfPlus, with: "")
        }
        
        let connectingURL = "getstarted/regusers?token=" + deviceToken + "&mobileno=" + mobileNumber + "&code=" + code + "&fname=" + firstName + "&lname=" + lastName
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shoulShowLoadingIndicator: true) { (response, errorMessage) in
            
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
