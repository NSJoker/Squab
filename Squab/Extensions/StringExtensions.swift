//
//  StringExtensions.swift
//  Squab
//
//  Created by Chandrachudh on 24/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func base64DecodedString()->String? {
        
//        let base64EncodedString = verifyBase64Encoding()
//
//        print("base64EncodedString.characters.count = ",base64EncodedString.characters.count)
//        if let data = Data(base64Encoded: base64EncodedString) {
//            return String(data: data, encoding: .utf8)
//        }
        
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func base64EncodedString() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func verifyBase64Encoding() -> String {
        let remainder = self.characters.count % 4
        if remainder == 0 {
            return self
        } else {
            // padding with equal
            let newLength = self.characters.count + (5 - remainder)
            print("Char count = ",self.characters.count)
            print("Newlaength = ",newLength)
            return self.padding(toLength: newLength, withPad: "\n", startingAt: 0)
        }
    }
}
