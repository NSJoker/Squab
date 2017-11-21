//
//  SQRecentFile.swift
//  Squab
//
//  Created by Chandrachudh on 21/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import SwiftyJSON

class SQRecentFile: NSObject {

    public var language:String?
    public var lastUpdatedTime:TimeInterval?
    public var searchResult:SQSearchResults?
    
    func getRecentFileDictionary() -> [String:Any] {
        
        var dict = [String:Any]()
        
        dict["language"] = language
        dict["searchResult"] = searchResult?.dictionaryRepresentation()
        dict["lastUpdatedTime"] = lastUpdatedTime
        
        return dict
    }
    
    class func getRecentFileFrom(dict:[String:Any]) -> SQRecentFile {
        
        let recentFile = SQRecentFile()
        
        recentFile.language = dict["language"] as? String
        recentFile.searchResult = SQSearchResults.init(json: JSON(dict["searchResult"]!))
        recentFile.lastUpdatedTime = dict["lastUpdatedTime"] as? TimeInterval
        
        return recentFile
    }
    
    func isSameAs(checkerFile:SQRecentFile) -> Bool {
        
        if checkerFile.language != language {
            return false
        }
        
        if checkerFile.searchResult?.docid != searchResult?.docid {
            return false
        }
        
        if checkerFile.searchResult?.filepath != searchResult?.filepath {
            return false
        }
        
        if checkerFile.searchResult?.filelink != searchResult?.filelink {
            return false
        }
        
        if checkerFile.searchResult?.icon != searchResult?.icon {
            return false
        }
        
        if checkerFile.searchResult?.title != searchResult?.title {
            return false
        }
        
        if checkerFile.searchResult?.username != searchResult?.username {
            return false
        }
        return true
        
    }
}
