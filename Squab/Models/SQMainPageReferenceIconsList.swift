//
//  SQMainPageReferenceIconsList.swift
//
//  Created by Chandrachudh on 06/11/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SQMainPageReferenceIconsList {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQMainPageReferenceIconsListFormatKey: String = "Format"
  private let kSQMainPageReferenceIconsListImageHeightKey: String = "ImageHeight"
  private let kSQMainPageReferenceIconsListReferenceIdKey: String = "ReferenceId"
  private let kSQMainPageReferenceIconsListByteDataKey: String = "ByteData"
  private let kSQMainPageReferenceIconsListFileNameKey: String = "FileName"
  private let kSQMainPageReferenceIconsListImageWidthKey: String = "ImageWidth"

  // MARK: Properties
  public var format: String?
  public var imageHeight: Int?
  public var referenceId: String?
  public var byteData: String?
  public var fileName: String?
  public var imageWidth: Int?

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
    format = json[kSQMainPageReferenceIconsListFormatKey].string
    imageHeight = json[kSQMainPageReferenceIconsListImageHeightKey].int
    referenceId = json[kSQMainPageReferenceIconsListReferenceIdKey].string
    byteData = json[kSQMainPageReferenceIconsListByteDataKey].string
    fileName = json[kSQMainPageReferenceIconsListFileNameKey].string
    imageWidth = json[kSQMainPageReferenceIconsListImageWidthKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = format { dictionary[kSQMainPageReferenceIconsListFormatKey] = value }
    if let value = imageHeight { dictionary[kSQMainPageReferenceIconsListImageHeightKey] = value }
    if let value = referenceId { dictionary[kSQMainPageReferenceIconsListReferenceIdKey] = value }
    if let value = byteData { dictionary[kSQMainPageReferenceIconsListByteDataKey] = value }
    if let value = fileName { dictionary[kSQMainPageReferenceIconsListFileNameKey] = value }
    if let value = imageWidth { dictionary[kSQMainPageReferenceIconsListImageWidthKey] = value }
    return dictionary
  }
}

extension SQMainPageReferenceIconsList {
    func getFile(searchResult:SQSearchResults, language:String, returnBlock:@escaping returnBlock) {
        
        guard let filelink = searchResult.filelink else {
            returnBlock(nil, "Invalid file link.")
            return
        }
        guard let filePath = searchResult.filepath?.base64DecodedString() else {
            returnBlock(nil, "Invalid file path.")
            return
        }
        var connectingURL = filelink
        if (filelink as NSString).contains("http") == false {
            connectingURL = "http://" + connectingURL
        }
        
        var parameterPart = "{\"accountId\":\"\",\"command\":1002,\"id\":\""
        parameterPart = parameterPart + referenceId!
        parameterPart = parameterPart + "\",\"fileName\":\""
        parameterPart = parameterPart + filePath + "_"
        parameterPart = parameterPart + language + "\",\"metadata\":\"\"}"
        parameterPart = parameterPart.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        connectingURL = connectingURL + "?input=" + parameterPart
        
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
                
                guard let responseString = String.init(data: data as! Data, encoding: .utf8) else {
                    returnBlock(nil, "Something went wrong")
                    return
                }                
                returnBlock(responseString, nil)
            }
        }
    }
}
