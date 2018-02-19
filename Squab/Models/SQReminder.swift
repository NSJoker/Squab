//
//  SQReminder.swift
//  Squab
//
//  Created by Chandrachudh on 01/01/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import UIKit
import SwiftyJSON

class SQReminder: NSObject {
    var reminderDate:Date?
    var reminderSearchResult:SQSearchResults?
    
    func dictionaryRepresentation()->[String:Any] {
        var dict = [String:Any]()
        dict["searchResult"] = reminderSearchResult?.dictionaryRepresentation()
        dict["date"] = reminderDate?.timeIntervalSince1970
        
        return dict
    }
    
    class func getReminderFromDict(dict:[String:Any])->SQReminder {
        
        let reminder = SQReminder()
        
        let timeStamp = dict["date"] as! Double
        reminder.reminderDate = Date.init(timeIntervalSince1970: timeStamp)
        
        let searchResultsDict = dict["searchResult"] as! [String:Any]
        reminder.reminderSearchResult = SQSearchResults.init(json: JSON(searchResultsDict))
        
        return reminder
    }
}
