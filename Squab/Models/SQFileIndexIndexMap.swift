//
//  SQFileIndexIndexMap.swift
//
//  Created by Chandrachudh on 30/10/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SQFileIndexIndexMap {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kSQFileIndexIndexMapKeyKey: String = "key"
  private let kSQFileIndexIndexMapValueKey: String = "value"

  // MARK: Properties
  public var key: String?
  public var value: SQFileIndexValue?

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
    key = json[kSQFileIndexIndexMapKeyKey].string
    value = SQFileIndexValue(json: json[kSQFileIndexIndexMapValueKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = key { dictionary[kSQFileIndexIndexMapKeyKey] = value }
    if let value = value { dictionary[kSQFileIndexIndexMapValueKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}
