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
  public var details: String?
  public var status: String?
    public var selectedMobileNumber:String?

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
    details = json[kSQLoginPhoneModelDetailsKey].string
    status = json[kSQLoginPhoneModelStatusKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = details { dictionary[kSQLoginPhoneModelDetailsKey] = value }
    if let value = status { dictionary[kSQLoginPhoneModelStatusKey] = value }
    return dictionary
  }

    class func loginWith(mobileNumber:String, countryCode:String, returnBlock:@escaping returnBlock) {
        
        let connectingURL = ":8083/getstarted/sendsms?number=" + mobileNumber + "&code" + countryCode
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                returnBlock(nil, errorMessage)
            }
            else {
                if let data = response {
                    do {
                        let responseModel = try JSONDecoder().decode(SQLoginPhoneModel.self, from: data as! Data)
                        responseModel.selectedMobileNumber = mobileNumber
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
        if let details = details {
            let connectingURL = "/getstarted/verifyotp?session=" + details + "&otp=" + otp
            
            SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil) { (response, errorMessage) in
                
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
}
