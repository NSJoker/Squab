//
//  SquabRecentItemsManager.swift
//  Squab
//
//  Created by Chandrachudh on 21/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SquabRecentItemsManager: NSObject {
    
    let saveLocation = "com.squab.recentFiles"
    
    class var sharedInstance: SquabRecentItemsManager {
        struct Static {
            static let instance: SquabRecentItemsManager = SquabRecentItemsManager()
        }
        return Static.instance
    }
    
    func addItemToRecent(searchResult:SQSearchResults, language:String) {
        
        let recentFile = SQRecentFile()
        
        recentFile.language = language
        recentFile.searchResult = searchResult
        recentFile.lastUpdatedTime = Date().timeIntervalSince1970
        
        saveRecentItem(recentFile: recentFile)
    }
    
    func saveRecentItem(recentFile:SQRecentFile) {
        
        var allRecentFiles = getAllSavedItems()
        var matchingIndex:Int = -1
        for i in 0..<allRecentFiles.count {
            let savedRecentFile = allRecentFiles[i]
            
            if savedRecentFile.isSameAs(checkerFile: recentFile) {
                matchingIndex = i
                break
            }
        }
        if matchingIndex >= 0 {
            allRecentFiles.remove(at: matchingIndex)
        }
        allRecentFiles.insert(recentFile, at: 0)
        var allDataToSave = [[String:Any]]()
        allRecentFiles.forEach { (fileToSave) in
            allDataToSave.append(fileToSave.getRecentFileDictionary())
        }
        UserDefaults.standard.set(allDataToSave, forKey: saveLocation)
    }
    
    func getAllSavedItems() -> [SQRecentFile] {
        var allRecentFiles = [SQRecentFile]()
        if let data = UserDefaults.standard.object(forKey: saveLocation) {
            let allSavedData = data as! [[String:Any]]
            allSavedData.forEach { (dict) in
                allRecentFiles.append(SQRecentFile.getRecentFileFrom(dict: dict))
            }
        }
        return allRecentFiles
    }
    
    func removeAllRecentItems() {
        UserDefaults.standard.removeObject(forKey: saveLocation)
    }
    
    func removeFile(fileToRemove:SQRecentFile) {
        var allRecentFiles = getAllSavedItems()
        
        var index:Int = -1
        
        for i in 0..<allRecentFiles.count {
            let recentFile = allRecentFiles[i]
            if recentFile.isSameAs(checkerFile: fileToRemove) {
                index = i
                break
            }
        }
        
        if index != -1 {
            allRecentFiles.remove(at: index)
        }
        
        var allDataToSave = [[String:Any]]()
        allRecentFiles.forEach { (fileToSave) in
            allDataToSave.append(fileToSave.getRecentFileDictionary())
        }
        UserDefaults.standard.set(allDataToSave, forKey: saveLocation)
    }
}
