//
//  SQSearchResults.swift
//
//  Created by Chandrachudh on 24/10/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SQSearchResults:Decodable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQSearchResultsFilepathKey: String = "filepath"
  private let kSQSearchResultsIconKey: String = "icon"
  private let kSQSearchResultsDocidKey: String = "docid"
  private let kSQSearchResultsSortbyascKey: String = "sortbyasc"
  private let kSQSearchResultsTitleKey: String = "title"
  private let kSQSearchResultsFilelinkKey: String = "filelink"
  private let kSQSearchResultsUsernameKey: String = "username"
  private let kSQSearchResultsCategoryKey: String = "category"

  // MARK: Properties
  public var filepath: String?
  public var icon: String?
  public var docid: String?
  public var sortbyasc: Int?
  public var title: String?
  public var filelink: String?
  public var username: String?
  public var category: String?

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
    filepath = json[kSQSearchResultsFilepathKey].string
    icon = json[kSQSearchResultsIconKey].string
    docid = json[kSQSearchResultsDocidKey].string
    sortbyasc = json[kSQSearchResultsSortbyascKey].int
    title = json[kSQSearchResultsTitleKey].string
    filelink = json[kSQSearchResultsFilelinkKey].string
    username = json[kSQSearchResultsUsernameKey].string
    category = json[kSQSearchResultsCategoryKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = filepath { dictionary[kSQSearchResultsFilepathKey] = value }
    if let value = icon { dictionary[kSQSearchResultsIconKey] = value }
    if let value = docid { dictionary[kSQSearchResultsDocidKey] = value }
    if let value = sortbyasc { dictionary[kSQSearchResultsSortbyascKey] = value }
    if let value = title { dictionary[kSQSearchResultsTitleKey] = value }
    if let value = filelink { dictionary[kSQSearchResultsFilelinkKey] = value }
    if let value = username { dictionary[kSQSearchResultsUsernameKey] = value }
    if let value = category { dictionary[kSQSearchResultsCategoryKey] = value }
    return dictionary
  }
    
    class func searchFor(searchText:String, returnBlock:@escaping returnBlock) {
        let mobileNumber = SquabUserManager.sharedInstance.getSavedMobileNumber()
        //let connectingURL = "http://squab.avartaka.com:9083/getstarted/getdoc?key=" + searchText + "&mobileno=" + mobileNumber
        let connectingURL = "getstarted/getdoc?key=" + searchText + "&mobileno=" + mobileNumber
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .GET, parameters: nil, shouldShowLoadingIndicator: false) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                returnBlock(nil, errorMessage)
            }
            else {
                if let data = response {
                    do {
                        let responseModel = try JSONDecoder().decode([SQSearchResults].self, from: data as! Data)
                        returnBlock(responseModel, nil)
                    }
                    catch let jsonError {
                        returnBlock(nil, jsonError.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getDetailsOfFile(returnBlock:@escaping returnBlock) {
        
        guard let filelink = filelink else {
            returnBlock(nil, "Invalid file link.")
            return
        }
        
        guard let filePath = filepath?.base64DecodedString() else {
            returnBlock(nil, "Invalid file path.")
            return
        }
        
        var connectingURL = filelink
        
        if (filelink as NSString).contains("http") == false {
            connectingURL = "http://" + connectingURL
        }
        
        let parameterPart = ("{\"accountId\":\"\",\"command\":2005,\"id\":\"\",\"fileName\":\"" + filePath + "\",\"metadata\":\"\"}").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        connectingURL = connectingURL + "?input=" + parameterPart!
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .POST, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                print("error found = ",errorMessage)
            }
            else {
                print("response = ",String.init(data: response as! Data, encoding: .utf8)!)
                
                if let data = response {
                    do {
                        let responseModel = try JSONDecoder().decode(SQLanguages.self, from: data as! Data)
                        returnBlock(responseModel, nil)
                    }
                    catch let jsonError {
                        returnBlock(nil, jsonError.localizedDescription)
                    }
                }
            }
        }
    }
    
    func getOriginalFile(language:String ,returnBlock:@escaping returnBlock) {
        
        guard let filelink = filelink else {
            returnBlock(nil, "Invalid file link.")
            return
        }
        
        guard let filePath = filepath?.base64DecodedString() else {
            returnBlock(nil, "Invalid file path.")
            return
        }
        
        var connectingURL = filelink
        
        if (filelink as NSString).contains("http") == false {
            connectingURL = "http://" + connectingURL
        }
        
        let parameterPart = ("{\"accountId\":\"\",\"command\":1008,\"id\":\"\",\"fileName\":\"" + filePath + "_" + language + "\",\"metadata\":\"\"}").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        connectingURL = connectingURL + "?input=" + parameterPart!
        
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .POST, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                print("error found = ",errorMessage)
            }
            else {
                
                guard let data = response else {
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String:Any]
                    let responseObject = SQFileIndexModel.init(json: JSON(json))
                    returnBlock(responseObject, nil)
                } catch let jsonError {
                    returnBlock(nil, jsonError.localizedDescription)
                }
                
            }
        }
    }
    
    func getDetailsUsingID(idStr:String, language:String ,returnBlock:@escaping returnBlock) {
        guard let filelink = filelink else {
            returnBlock(nil, "Invalid file link.")
            return
        }
        guard let filePath = filepath?.base64DecodedString() else {
            returnBlock(nil, "Invalid file path.")
            return
        }
        var connectingURL = filelink
        if (filelink as NSString).contains("http") == false {
            connectingURL = "http://" + connectingURL
        }
        let parameterPart = ("{\"accountId\":\"\",\"command\":1002,\"id\":\"" + idStr + "\",\"fileName\":\"" + filePath + "_" + language + "\",\"metadata\":\"\"}").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        connectingURL = connectingURL + "?input=" + parameterPart!
        SquabDataCenter.sharedInstance.sendRequest(connectingURL: connectingURL, httpMethod: .POST, parameters: nil, shouldShowLoadingIndicator: true) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                 returnBlock(nil, errorMessage)
            }
            else {
                guard let data = response else {
                    returnBlock(nil, "Something went wrong")
                    return
                }
                guard let encodedResponseString = String.init(data: data as! Data, encoding: .utf8) else {
                    returnBlock(nil, "Something went wrong")
                    return
                }
                let responseJSONAsString = encodedResponseString.base64DecodedString()
                 if let encodedResponseString = String.init(data: data as! Data, encoding: .utf8) {
                 let responseJSONAsString = encodedResponseString.base64DecodedString()
                 
                 let detailsData = responseJSONAsString?.data(using: .utf8)
                 
                 do {
                 let json = try JSONSerialization.jsonObject(with: detailsData as! Data, options: []) as? [String:Any]
                    let responseModel = SQMainPageModel.init(json: JSON(json!))
                    returnBlock(responseModel, nil)
                 } catch let error{
                    returnBlock(nil, error.localizedDescription)
                 }
             }
            }
        }
    }
}
