//
//  SquabBase64ConvertionHelper.swift
//  Squab
//
//  Created by Chandrachudh on 24/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SquabBase64ConvertionHelper: NSObject {

    class var sharedInstance: SquabBase64ConvertionHelper {
        struct Static {
            static let instance: SquabBase64ConvertionHelper = SquabBase64ConvertionHelper()
        }
        return Static.instance
    }
    
    func getImageFromBase64EncodedString(base64String:String)->UIImage? {
        
        if let data = Data.init(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            if let image = UIImage.init(data: data) {
                return image
            }
        }
        return nil
    }
}
