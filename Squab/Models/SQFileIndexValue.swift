//
//  SQFileIndexValue.swift
//
//  Created by Chandrachudh on 30/10/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SQFileIndexValue {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQFileIndexValueUiidKey: String = "uiid"
  private let kSQFileIndexValueImplementationsKey: String = "implementations"
  private let kSQFileIndexValueIsSkippedKey: String = "isSkipped"
  private let kSQFileIndexValueIsNotifiedKey: String = "isNotified"
  private let kSQFileIndexValueIsMandatoryKey: String = "isMandatory"
  private let kSQFileIndexValueIsReviewDoneKey: String = "isReviewDone"
  private let kSQFileIndexValueRootIndexKey: String = "rootIndex"
  private let kSQFileIndexValueIsPausedKey: String = "isPaused"
  private let kSQFileIndexValueReviewsKey: String = "reviews"
  private let kSQFileIndexValueIndexKey: String = "index"
  private let kSQFileIndexValueInternalIdentifierKey: String = "id"
  private let kSQFileIndexValueReviewIdKey: String = "reviewId"
  private let kSQFileIndexValueIsReviewOkOrNotOkKey: String = "isReviewOkOrNotOk"
  private let kSQFileIndexValueIsAbortedKey: String = "isAborted"
  private let kSQFileIndexValueTitleKey: String = "title"
  private let kSQFileIndexValueUseridKey: String = "userid"
  private let kSQFileIndexValuePauseDetailsKey: String = "pauseDetails"

  // MARK: Properties
  public var uiid: Int?
  public var implementations: [Any]?
  public var isSkipped: String?
  public var isNotified: String?
  public var isMandatory: String?
  public var isReviewDone: String?
  public var rootIndex: String?
  public var isPaused: String?
  public var reviews: [Any]?
  public var index: String?
  public var internalIdentifier: String?
  public var reviewId: Int?
  public var isReviewOkOrNotOk: String?
  public var isAborted: String?
  public var title: String?
  public var userid: String?
  public var pauseDetails: [Any]?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    uiid = json[kSQFileIndexValueUiidKey].int
    if let items = json[kSQFileIndexValueImplementationsKey].array { implementations = items.map { $0.object} }
    isSkipped = json[kSQFileIndexValueIsSkippedKey].string
    isNotified = json[kSQFileIndexValueIsNotifiedKey].string
    isMandatory = json[kSQFileIndexValueIsMandatoryKey].string
    isReviewDone = json[kSQFileIndexValueIsReviewDoneKey].string
    rootIndex = json[kSQFileIndexValueRootIndexKey].string
    isPaused = json[kSQFileIndexValueIsPausedKey].string
    if let items = json[kSQFileIndexValueReviewsKey].array { reviews = items.map { $0.object} }
    index = json[kSQFileIndexValueIndexKey].string
    internalIdentifier = json[kSQFileIndexValueInternalIdentifierKey].string
    reviewId = json[kSQFileIndexValueReviewIdKey].int
    isReviewOkOrNotOk = json[kSQFileIndexValueIsReviewOkOrNotOkKey].string
    isAborted = json[kSQFileIndexValueIsAbortedKey].string
    title = json[kSQFileIndexValueTitleKey].string
    userid = json[kSQFileIndexValueUseridKey].string
    if let items = json[kSQFileIndexValuePauseDetailsKey].array { pauseDetails = items.map { $0.object} }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = uiid { dictionary[kSQFileIndexValueUiidKey] = value }
    if let value = implementations { dictionary[kSQFileIndexValueImplementationsKey] = value }
    if let value = isSkipped { dictionary[kSQFileIndexValueIsSkippedKey] = value }
    if let value = isNotified { dictionary[kSQFileIndexValueIsNotifiedKey] = value }
    if let value = isMandatory { dictionary[kSQFileIndexValueIsMandatoryKey] = value }
    if let value = isReviewDone { dictionary[kSQFileIndexValueIsReviewDoneKey] = value }
    if let value = rootIndex { dictionary[kSQFileIndexValueRootIndexKey] = value }
    if let value = isPaused { dictionary[kSQFileIndexValueIsPausedKey] = value }
    if let value = reviews { dictionary[kSQFileIndexValueReviewsKey] = value }
    if let value = index { dictionary[kSQFileIndexValueIndexKey] = value }
    if let value = internalIdentifier { dictionary[kSQFileIndexValueInternalIdentifierKey] = value }
    if let value = reviewId { dictionary[kSQFileIndexValueReviewIdKey] = value }
    if let value = isReviewOkOrNotOk { dictionary[kSQFileIndexValueIsReviewOkOrNotOkKey] = value }
    if let value = isAborted { dictionary[kSQFileIndexValueIsAbortedKey] = value }
    if let value = title { dictionary[kSQFileIndexValueTitleKey] = value }
    if let value = userid { dictionary[kSQFileIndexValueUseridKey] = value }
    if let value = pauseDetails { dictionary[kSQFileIndexValuePauseDetailsKey] = value }
    return dictionary
  }

}
