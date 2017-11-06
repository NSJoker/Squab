//
//  SQMainPageModel.swift
//
//  Created by Chandrachudh on 06/11/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SQMainPageModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQMainPageModelRootIdKey: String = "RootId"
  private let kSQMainPageModelInstructionIdKey: String = "InstructionId"
  private let kSQMainPageModelReferenceIconsListKey: String = "ReferenceIconsList"
  private let kSQMainPageModelHeaderKey: String = "Header"
  private let kSQMainPageModelInstructionIndexKey: String = "InstructionIndex"
  private let kSQMainPageModelIsReviewedKey: String = "IsReviewed"
  private let kSQMainPageModelShowNotificationKey: String = "ShowNotification"
  private let kSQMainPageModelDescriptionKey: String = "Description"
  private let kSQMainPageModelInstructionRootIndexKey: String = "InstructionRootIndex"
  private let kSQMainPageModelIsMandatoryKey: String = "IsMandatory"
  private let kSQMainPageModelIsViewedKey: String = "IsViewed"
  private let kSQMainPageModelPageNumberKey: String = "PageNumber"
  private let kSQMainPageModelIsReviewedOkKey: String = "IsReviewedOk"

  // MARK: Properties
  public var rootId: String?
  public var instructionId: String?
  public var referenceIconsList: [SQMainPageReferenceIconsList]?
  public var header: String?
  public var instructionIndex: String?
  public var isReviewed: Bool = false
  public var showNotification: Bool = false
  public var description: String?
  public var instructionRootIndex: String?
  public var isMandatory: Bool = false
  public var isViewed: Bool = false
  public var pageNumber: Int?
  public var isReviewedOk: Bool = false

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
    rootId = json[kSQMainPageModelRootIdKey].string
    instructionId = json[kSQMainPageModelInstructionIdKey].string
    if let items = json[kSQMainPageModelReferenceIconsListKey].array { referenceIconsList = items.map { SQMainPageReferenceIconsList(json: $0) } }
    header = json[kSQMainPageModelHeaderKey].string
    instructionIndex = json[kSQMainPageModelInstructionIndexKey].string
    isReviewed = json[kSQMainPageModelIsReviewedKey].boolValue
    showNotification = json[kSQMainPageModelShowNotificationKey].boolValue
    description = json[kSQMainPageModelDescriptionKey].string
    instructionRootIndex = json[kSQMainPageModelInstructionRootIndexKey].string
    isMandatory = json[kSQMainPageModelIsMandatoryKey].boolValue
    isViewed = json[kSQMainPageModelIsViewedKey].boolValue
    pageNumber = json[kSQMainPageModelPageNumberKey].int
    isReviewedOk = json[kSQMainPageModelIsReviewedOkKey].boolValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = rootId { dictionary[kSQMainPageModelRootIdKey] = value }
    if let value = instructionId { dictionary[kSQMainPageModelInstructionIdKey] = value }
    if let value = referenceIconsList { dictionary[kSQMainPageModelReferenceIconsListKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = header { dictionary[kSQMainPageModelHeaderKey] = value }
    if let value = instructionIndex { dictionary[kSQMainPageModelInstructionIndexKey] = value }
    dictionary[kSQMainPageModelIsReviewedKey] = isReviewed
    dictionary[kSQMainPageModelShowNotificationKey] = showNotification
    if let value = description { dictionary[kSQMainPageModelDescriptionKey] = value }
    if let value = instructionRootIndex { dictionary[kSQMainPageModelInstructionRootIndexKey] = value }
    dictionary[kSQMainPageModelIsMandatoryKey] = isMandatory
    dictionary[kSQMainPageModelIsViewedKey] = isViewed
    if let value = pageNumber { dictionary[kSQMainPageModelPageNumberKey] = value }
    dictionary[kSQMainPageModelIsReviewedOkKey] = isReviewedOk
    return dictionary
  }

}
