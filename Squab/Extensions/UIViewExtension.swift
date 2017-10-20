//
//  UIViewExtension.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    func addShadowWith(shadowPath:CGPath, shadowColor:CGColor, shadowOpacity:Float, shadowRadius:CGFloat, shadowOffset:CGSize) {
        layer.masksToBounds = true
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        clipsToBounds = false
        layer.shadowPath = shadowPath
    }
}
