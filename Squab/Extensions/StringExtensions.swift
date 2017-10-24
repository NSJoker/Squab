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
        if let data = Data(base64Encoded: self) {
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
}
